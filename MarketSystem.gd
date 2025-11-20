extends Node
class_name MarketSystem
## MarketSystem - Dynamic player-driven economy (EVE Online/X4-inspired)
##
## Features:
## - Supply & Demand price calculation
## - Market trends with multiple timeframes (5min, 30min, 1h, 2h, 24h, 1 week)
## - Player-driven economy (Buy/Sell orders)
## - Order book system
## - Market history tracking with detailed resolution
## - NPC market seeding
##
## Usage:
## ```gdscript
## var price = MarketSystem.get_current_price("ORE_VELDSPAR", station_id)
## MarketSystem.place_buy_order("ORE_VELDSPAR", 100.0, 150.0, player_id, station_id)
## ```

# ============================================================================
# SIGNALS
# ============================================================================

signal price_changed(item_id: String, station_id: String, old_price: float, new_price: float)
signal market_trend_changed(item_id: String, trend: TrendDirection, timeframe: String)
signal stock_level_changed(item_id: String, station_id: String, stock: float)
signal transaction_completed(buyer_id: String, seller_id: String, item_id: String, amount: float, price: float)
signal order_placed(order_id: String, order_type: OrderType, item_id: String, amount: float, price: float)
signal order_filled(order_id: String)
signal order_cancelled(order_id: String)
signal market_shortage(item_id: String, station_id: String)
signal market_surplus(item_id: String, station_id: String)

# ============================================================================
# ENUMS
# ============================================================================

enum TrendDirection {
	CRASHING = -2,  # -20% or more
	DECLINING = -1,  # -5% to -20%
	STABLE = 0,      # -5% to +5%
	RISING = 1,      # +5% to +20%
	SURGING = 2      # +20% or more
}

enum OrderType {
	BUY_ORDER,   # Player wants to buy at specified price
	SELL_ORDER   # Player wants to sell at specified price
}

enum TimeFrame {
	MIN_5 = 0,    # 5 minutes
	MIN_30 = 1,   # 30 minutes
	HOUR_1 = 2,   # 1 hour
	HOUR_2 = 3,   # 2 hours
	HOUR_24 = 4,  # 24 hours (1 day)
	WEEK_1 = 5    # 1 week
}

# ============================================================================
# CONSTANTS
# ============================================================================

const MARKET_UPDATE_INTERVAL = 5.0   # Update market every 5 seconds (faster for charts)
const PRICE_HISTORY_MAX_POINTS = {
	TimeFrame.MIN_5: 60,      # 60 points = 5 minutes at 5sec intervals
	TimeFrame.MIN_30: 360,    # 360 points = 30 minutes
	TimeFrame.HOUR_1: 720,    # 720 points = 1 hour
	TimeFrame.HOUR_2: 1440,   # 1440 points = 2 hours
	TimeFrame.HOUR_24: 17280, # 17280 points = 24 hours
	TimeFrame.WEEK_1: 120960  # 120960 points = 1 week
}

const MIN_PRICE_MULTIPLIER = 0.1     # Prices can't go below 10% of base
const MAX_PRICE_MULTIPLIER = 10.0    # Prices can't go above 1000% of base

## Price elasticity (how much prices change based on supply/demand)
const PRICE_ELASTICITY = 0.05  # 5% change per 100% stock deviation

## Stock thresholds (relative to optimal stock)
const SHORTAGE_THRESHOLD = 0.25   # Below 25% = shortage
const SURPLUS_THRESHOLD = 2.0     # Above 200% = surplus

## Transaction impact on price (volume-based)
const TRANSACTION_IMPACT_FACTOR = 0.001  # 0.1% price change per 1% of daily volume

## Order expiration time (seconds)
const ORDER_EXPIRATION_TIME = 2592000.0  # 30 days

# ============================================================================
# STATE
# ============================================================================

## Market data: station_id -> item_id -> MarketData
var market_data: Dictionary = {}

## Base prices (from database): item_id -> base_price
var base_prices: Dictionary = {}

## Price history: item_id -> station_id -> TimeFrame -> Array[PricePoint]
var price_history: Dictionary = {}

## Active buy orders: station_id -> item_id -> Array[OrderData]
var buy_orders: Dictionary = {}

## Active sell orders: station_id -> item_id -> Array[OrderData]
var sell_orders: Dictionary = {}

## Market trends per timeframe: item_id -> TimeFrame -> TrendDirection
var market_trends: Dictionary = {}

## Daily transaction volumes: station_id -> item_id -> volume
var daily_volumes: Dictionary = {}

## Time tracking
var market_time: float = 0.0
var time_since_update: float = 0.0

# ============================================================================
# DATA STRUCTURES
# ============================================================================

class MarketData:
	var item_id: String
	var station_id: String
	var current_price: float
	var base_price: float
	var stock: float
	var optimal_stock: float
	var consumption_rate: float  # Per hour
	var production_rate: float   # Per hour
	var last_update: float
	var best_buy_price: float    # Highest buy order
	var best_sell_price: float   # Lowest sell order

	func _init(p_item_id: String, p_station_id: String, p_base_price: float, p_optimal_stock: float):
		item_id = p_item_id
		station_id = p_station_id
		base_price = p_base_price
		current_price = p_base_price
		optimal_stock = p_optimal_stock
		stock = p_optimal_stock
		consumption_rate = 0.0
		production_rate = 0.0
		last_update = 0.0
		best_buy_price = 0.0
		best_sell_price = 0.0

class PricePoint:
	var timestamp: float
	var price: float
	var volume: float

	func _init(p_timestamp: float, p_price: float, p_volume: float = 0.0):
		timestamp = p_timestamp
		price = p_price
		volume = p_volume

class OrderData:
	var order_id: String
	var order_type: OrderType
	var item_id: String
	var station_id: String
	var player_id: String
	var amount: float
	var price: float
	var timestamp: float
	var expires_at: float

	func _init(p_order_id: String, p_type: OrderType, p_item_id: String, p_station_id: String,
	           p_player_id: String, p_amount: float, p_price: float):
		order_id = p_order_id
		order_type = p_type
		item_id = p_item_id
		station_id = p_station_id
		player_id = p_player_id
		amount = p_amount
		price = p_price
		timestamp = Time.get_unix_time_from_system()
		expires_at = timestamp + ORDER_EXPIRATION_TIME

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	print("💰 MarketSystem: Initializing...")
	_load_base_prices()
	_initialize_markets()
	_seed_initial_stock()
	print("✅ MarketSystem: Ready")

func _process(delta: float):
	market_time += delta
	time_since_update += delta

	# Update market periodically
	if time_since_update >= MARKET_UPDATE_INTERVAL:
		_update_all_markets()
		_process_orders()
		time_since_update = 0.0

# ============================================================================
# INITIALIZATION
# ============================================================================

func _load_base_prices():
	"""Load base prices from ItemDatabase"""
	if not DatabaseManager:
		push_error("MarketSystem: DatabaseManager not found!")
		return

	var all_items = DatabaseManager.get_all_item_ids()
	for item_id in all_items:
		var item_data = DatabaseManager.get_item_data(item_id)
		if item_data and item_data.has("base_value"):
			base_prices[item_id] = float(item_data["base_value"])
		else:
			base_prices[item_id] = 100.0  # Default fallback

	print("💰 MarketSystem: Loaded %d base prices" % base_prices.size())

func _initialize_markets():
	"""Initialize market data for all stations"""
	var test_stations = ["STATION_JITA", "STATION_AMARR", "STATION_DODIXIE", "STATION_RENS"]

	for station_id in test_stations:
		market_data[station_id] = {}
		daily_volumes[station_id] = {}
		buy_orders[station_id] = {}
		sell_orders[station_id] = {}

		# Initialize market for all items at this station
		for item_id in base_prices.keys():
			var base_price = base_prices[item_id]
			var optimal_stock = _calculate_optimal_stock(item_id, station_id)

			market_data[station_id][item_id] = MarketData.new(item_id, station_id, base_price, optimal_stock)
			daily_volumes[station_id][item_id] = 0.0
			buy_orders[station_id][item_id] = []
			sell_orders[station_id][item_id] = []

	print("💰 MarketSystem: Initialized markets for %d stations" % test_stations.size())

func _calculate_optimal_stock(item_id: String, station_id: String) -> float:
	"""Calculate optimal stock level for an item at a station"""
	var base_optimal = 10000.0

	if item_id.begins_with("ORE_"):
		base_optimal = 50000.0
	elif item_id.begins_with("MAT_"):
		base_optimal = 20000.0
	elif item_id.begins_with("COMP_"):
		base_optimal = 10000.0
	elif item_id.begins_with("WEP_") or item_id.begins_with("MOD_"):
		base_optimal = 1000.0

	return base_optimal

func _seed_initial_stock():
	"""Seed markets with initial stock"""
	for station_id in market_data.keys():
		for item_id in market_data[station_id].keys():
			var market = market_data[station_id][item_id]
			market.stock = market.optimal_stock * randf_range(0.8, 1.2)
			market.consumption_rate = market.optimal_stock * 0.05  # 5% per hour
			market.production_rate = market.optimal_stock * 0.04   # 4% per hour

	print("💰 MarketSystem: Initial stock seeded")

# ============================================================================
# MARKET UPDATES
# ============================================================================

func _update_all_markets():
	"""Update all markets - prices, stock, trends"""
	for station_id in market_data.keys():
		for item_id in market_data[station_id].keys():
			_update_market_entry(station_id, item_id)

	_update_all_trends()

func _update_market_entry(station_id: String, item_id: String):
	"""Update a single market entry"""
	var market = market_data[station_id][item_id]

	# Update stock (consumption - production)
	var delta_time = MARKET_UPDATE_INTERVAL / 3600.0  # Convert to hours
	var consumption = market.consumption_rate * delta_time
	var production = market.production_rate * delta_time

	market.stock += production - consumption
	market.stock = max(0.0, market.stock)

	# Update price based on supply/demand
	var old_price = market.current_price
	_recalculate_price(market)

	# Update best buy/sell from order book
	_update_best_prices(market)

	# Record price point for all timeframes
	_record_price_points(item_id, station_id, market.current_price, daily_volumes[station_id][item_id])

	# Check for shortage/surplus
	_check_stock_levels(market)

	if old_price != market.current_price:
		price_changed.emit(item_id, station_id, old_price, market.current_price)

	market.last_update = market_time

func _recalculate_price(market: MarketData):
	"""Recalculate price based on supply/demand"""
	var stock_ratio = market.stock / market.optimal_stock
	var price_multiplier = 1.0 + (1.0 - stock_ratio) * PRICE_ELASTICITY
	price_multiplier = clamp(price_multiplier, MIN_PRICE_MULTIPLIER, MAX_PRICE_MULTIPLIER)
	market.current_price = market.base_price * price_multiplier

func _update_best_prices(market: MarketData):
	"""Update best buy/sell prices from order book"""
	var station_id = market.station_id
	var item_id = market.item_id

	# Best buy price = highest buy order
	market.best_buy_price = 0.0
	if buy_orders[station_id].has(item_id):
		for order in buy_orders[station_id][item_id]:
			if order.price > market.best_buy_price:
				market.best_buy_price = order.price

	# Best sell price = lowest sell order
	market.best_sell_price = INF
	if sell_orders[station_id].has(item_id):
		for order in sell_orders[station_id][item_id]:
			if order.price < market.best_sell_price:
				market.best_sell_price = order.price

	if market.best_sell_price == INF:
		market.best_sell_price = 0.0

func _check_stock_levels(market: MarketData):
	"""Check if stock is in shortage or surplus"""
	var stock_ratio = market.stock / market.optimal_stock

	if stock_ratio < SHORTAGE_THRESHOLD:
		market_shortage.emit(market.item_id, market.station_id)
	elif stock_ratio > SURPLUS_THRESHOLD:
		market_surplus.emit(market.item_id, market.station_id)

# ============================================================================
# PRICE HISTORY (Multiple Timeframes)
# ============================================================================

func _record_price_points(item_id: String, station_id: String, price: float, volume: float):
	"""Record price point for all timeframes"""
	if not price_history.has(item_id):
		price_history[item_id] = {}

	if not price_history[item_id].has(station_id):
		price_history[item_id][station_id] = {}
		for timeframe in TimeFrame.values():
			price_history[item_id][station_id][timeframe] = []

	var point = PricePoint.new(market_time, price, volume)

	for timeframe in TimeFrame.values():
		var history = price_history[item_id][station_id][timeframe]
		history.append(point)

		# Trim old history
		var max_points = PRICE_HISTORY_MAX_POINTS[timeframe]
		if history.size() > max_points:
			history.pop_front()

# ============================================================================
# TRENDS (Per Timeframe)
# ============================================================================

func _update_all_trends():
	"""Calculate market trends for all timeframes"""
	for item_id in price_history.keys():
		for timeframe in TimeFrame.values():
			var trend = _calculate_trend(item_id, timeframe)

			if not market_trends.has(item_id):
				market_trends[item_id] = {}

			var old_trend = market_trends[item_id].get(timeframe, TrendDirection.STABLE)
			if old_trend != trend:
				market_trends[item_id][timeframe] = trend
				var tf_name = TimeFrame.keys()[timeframe]
				market_trend_changed.emit(item_id, trend, tf_name)

func _calculate_trend(item_id: String, timeframe: int) -> TrendDirection:
	"""Calculate trend for an item across all stations for a specific timeframe"""
	if not price_history.has(item_id):
		return TrendDirection.STABLE

	var total_change_percent = 0.0
	var station_count = 0

	for station_id in price_history[item_id].keys():
		if not price_history[item_id][station_id].has(timeframe):
			continue

		var history = price_history[item_id][station_id][timeframe]
		if history.size() < 2:
			continue

		# Compare latest price to oldest in timeframe
		var latest_price = history[-1].price
		var old_price = history[0].price

		if old_price > 0:
			var change_percent = ((latest_price - old_price) / old_price) * 100.0
			total_change_percent += change_percent
			station_count += 1

	if station_count == 0:
		return TrendDirection.STABLE

	var avg_change = total_change_percent / station_count

	if avg_change <= -20.0:
		return TrendDirection.CRASHING
	elif avg_change <= -5.0:
		return TrendDirection.DECLINING
	elif avg_change >= 20.0:
		return TrendDirection.SURGING
	elif avg_change >= 5.0:
		return TrendDirection.RISING
	else:
		return TrendDirection.STABLE

# ============================================================================
# ORDER BOOK SYSTEM
# ============================================================================

func place_buy_order(item_id: String, amount: float, price: float, player_id: String, station_id: String) -> String:
	"""Player places a buy order"""
	if not _validate_market(station_id, item_id):
		return ""

	var order_id = "BUY_%d_%s" % [Time.get_unix_time_from_system(), player_id]
	var order = OrderData.new(order_id, OrderType.BUY_ORDER, item_id, station_id, player_id, amount, price)

	buy_orders[station_id][item_id].append(order)
	_sort_buy_orders(station_id, item_id)

	order_placed.emit(order_id, OrderType.BUY_ORDER, item_id, amount, price)

	print("💰 Buy order placed: %s wants %.1f %s @ %.2f credits" % [player_id, amount, item_id, price])

	# Try to match with sell orders immediately
	_try_match_orders(station_id, item_id)

	return order_id

func place_sell_order(item_id: String, amount: float, price: float, player_id: String, station_id: String) -> String:
	"""Player places a sell order"""
	if not _validate_market(station_id, item_id):
		return ""

	var order_id = "SELL_%d_%s" % [Time.get_unix_time_from_system(), player_id]
	var order = OrderData.new(order_id, OrderType.SELL_ORDER, item_id, station_id, player_id, amount, price)

	sell_orders[station_id][item_id].append(order)
	_sort_sell_orders(station_id, item_id)

	order_placed.emit(order_id, OrderType.SELL_ORDER, item_id, amount, price)

	print("💰 Sell order placed: %s offers %.1f %s @ %.2f credits" % [player_id, amount, item_id, price])

	# Try to match with buy orders immediately
	_try_match_orders(station_id, item_id)

	return order_id

func cancel_order(order_id: String) -> bool:
	"""Cancel an order"""
	# Find and remove order
	for station_id in buy_orders.keys():
		for item_id in buy_orders[station_id].keys():
			for i in range(buy_orders[station_id][item_id].size()):
				if buy_orders[station_id][item_id][i].order_id == order_id:
					buy_orders[station_id][item_id].remove_at(i)
					order_cancelled.emit(order_id)
					return true

	for station_id in sell_orders.keys():
		for item_id in sell_orders[station_id].keys():
			for i in range(sell_orders[station_id][item_id].size()):
				if sell_orders[station_id][item_id][i].order_id == order_id:
					sell_orders[station_id][item_id].remove_at(i)
					order_cancelled.emit(order_id)
					return true

	return false

func _try_match_orders(station_id: String, item_id: String):
	"""Try to match buy and sell orders"""
	if not buy_orders[station_id].has(item_id) or not sell_orders[station_id].has(item_id):
		return

	var buy_list = buy_orders[station_id][item_id]
	var sell_list = sell_orders[station_id][item_id]

	while buy_list.size() > 0 and sell_list.size() > 0:
		var best_buy = buy_list[0]  # Highest price
		var best_sell = sell_list[0]  # Lowest price

		# Can match if buy price >= sell price
		if best_buy.price >= best_sell.price:
			var trade_amount = min(best_buy.amount, best_sell.amount)
			var trade_price = (best_buy.price + best_sell.price) / 2.0  # Average

			# Execute trade
			transaction_completed.emit(best_buy.player_id, best_sell.player_id, item_id, trade_amount, trade_price)

			print("💰 Order matched: %.1f %s @ %.2f credits (Buyer: %s, Seller: %s)" %
			      [trade_amount, item_id, trade_price, best_buy.player_id, best_sell.player_id])

			# Update order amounts
			best_buy.amount -= trade_amount
			best_sell.amount -= trade_amount

			# Remove filled orders
			if best_buy.amount <= 0:
				buy_list.pop_front()
				order_filled.emit(best_buy.order_id)

			if best_sell.amount <= 0:
				sell_list.pop_front()
				order_filled.emit(best_sell.order_id)
		else:
			break  # No more matches possible

func _sort_buy_orders(station_id: String, item_id: String):
	"""Sort buy orders by price (highest first)"""
	buy_orders[station_id][item_id].sort_custom(func(a, b): return a.price > b.price)

func _sort_sell_orders(station_id: String, item_id: String):
	"""Sort sell orders by price (lowest first)"""
	sell_orders[station_id][item_id].sort_custom(func(a, b): return a.price < b.price)

func _process_orders():
	"""Process and clean up expired orders"""
	var current_time = Time.get_unix_time_from_system()

	for station_id in buy_orders.keys():
		for item_id in buy_orders[station_id].keys():
			buy_orders[station_id][item_id] = buy_orders[station_id][item_id].filter(
				func(order): return order.expires_at > current_time
			)

	for station_id in sell_orders.keys():
		for item_id in sell_orders[station_id].keys():
			sell_orders[station_id][item_id] = sell_orders[station_id][item_id].filter(
				func(order): return order.expires_at > current_time
			)

func _validate_market(station_id: String, item_id: String) -> bool:
	"""Validate market exists"""
	if not market_data.has(station_id):
		push_error("MarketSystem: Station not found: " + station_id)
		return false

	if not market_data[station_id].has(item_id):
		push_error("MarketSystem: Item not found: " + item_id)
		return false

	return true

# ============================================================================
# TRANSACTION API (Instant Buy/Sell)
# ============================================================================

func buy_instant(item_id: String, amount: float, buyer_id: String, station_id: String) -> bool:
	"""Instant buy from best sell order or station"""
	if not _validate_market(station_id, item_id):
		return false

	var market = market_data[station_id][item_id]

	# Try to buy from sell orders first
	if sell_orders[station_id][item_id].size() > 0:
		var best_sell = sell_orders[station_id][item_id][0]
		var trade_amount = min(amount, best_sell.amount)

		transaction_completed.emit(buyer_id, best_sell.player_id, item_id, trade_amount, best_sell.price)

		best_sell.amount -= trade_amount
		if best_sell.amount <= 0:
			sell_orders[station_id][item_id].pop_front()
			order_filled.emit(best_sell.order_id)

		return true

	# Fallback: buy from station stock
	if market.stock < amount:
		return false

	market.stock -= amount
	daily_volumes[station_id][item_id] += amount
	_apply_transaction_impact(market, amount, true)

	transaction_completed.emit(buyer_id, "STATION", item_id, amount, market.current_price)
	stock_level_changed.emit(item_id, station_id, market.stock)

	return true

func sell_instant(item_id: String, amount: float, seller_id: String, station_id: String) -> bool:
	"""Instant sell to best buy order or station"""
	if not _validate_market(station_id, item_id):
		return false

	var market = market_data[station_id][item_id]

	# Try to sell to buy orders first
	if buy_orders[station_id][item_id].size() > 0:
		var best_buy = buy_orders[station_id][item_id][0]
		var trade_amount = min(amount, best_buy.amount)

		transaction_completed.emit(best_buy.player_id, seller_id, item_id, trade_amount, best_buy.price)

		best_buy.amount -= trade_amount
		if best_buy.amount <= 0:
			buy_orders[station_id][item_id].pop_front()
			order_filled.emit(best_buy.order_id)

		return true

	# Fallback: sell to station
	market.stock += amount
	daily_volumes[station_id][item_id] += amount
	_apply_transaction_impact(market, amount, false)

	transaction_completed.emit(seller_id, "STATION", item_id, amount, market.current_price)
	stock_level_changed.emit(item_id, station_id, market.stock)

	return true

func _apply_transaction_impact(market: MarketData, amount: float, is_buy: bool):
	"""Apply transaction impact on price"""
	var daily_volume = daily_volumes[market.station_id][market.item_id]
	if daily_volume == 0:
		daily_volume = market.optimal_stock * 0.1

	var volume_percent = (amount / daily_volume) * 100.0
	var price_impact = volume_percent * TRANSACTION_IMPACT_FACTOR

	if is_buy:
		market.current_price *= (1.0 + price_impact)
	else:
		market.current_price *= (1.0 - price_impact)

	market.current_price = clamp(market.current_price,
	                               market.base_price * MIN_PRICE_MULTIPLIER,
	                               market.base_price * MAX_PRICE_MULTIPLIER)

# ============================================================================
# QUERY API
# ============================================================================

func get_current_price(item_id: String, station_id: String) -> float:
	"""Get current market price"""
	if not _validate_market(station_id, item_id):
		return base_prices.get(item_id, 100.0)
	return market_data[station_id][item_id].current_price

func get_stock(item_id: String, station_id: String) -> float:
	"""Get current stock level"""
	if not _validate_market(station_id, item_id):
		return 0.0
	return market_data[station_id][item_id].stock

func get_price_history(item_id: String, station_id: String, timeframe: int) -> Array:
	"""Get price history for charting"""
	if not price_history.has(item_id) or not price_history[item_id].has(station_id):
		return []

	if not price_history[item_id][station_id].has(timeframe):
		return []

	return price_history[item_id][station_id][timeframe]

func get_market_trend(item_id: String, timeframe: int) -> TrendDirection:
	"""Get current market trend for timeframe"""
	if not market_trends.has(item_id) or not market_trends[item_id].has(timeframe):
		return TrendDirection.STABLE
	return market_trends[item_id][timeframe]

func get_order_book(item_id: String, station_id: String) -> Dictionary:
	"""Get order book (buy and sell orders)"""
	if not _validate_market(station_id, item_id):
		return {"buy_orders": [], "sell_orders": []}

	return {
		"buy_orders": buy_orders[station_id][item_id].duplicate(),
		"sell_orders": sell_orders[station_id][item_id].duplicate()
	}

func get_best_prices(item_id: String, station_id: String) -> Dictionary:
	"""Get best buy/sell prices"""
	if not _validate_market(station_id, item_id):
		return {"buy": 0.0, "sell": 0.0}

	var market = market_data[station_id][item_id]
	return {
		"buy": market.best_buy_price,
		"sell": market.best_sell_price
	}

func get_all_markets_for_item(item_id: String) -> Array:
	"""Get all station markets for an item"""
	var markets = []
	for station_id in market_data.keys():
		if market_data[station_id].has(item_id):
			markets.append({
				"station_id": station_id,
				"price": market_data[station_id][item_id].current_price,
				"stock": market_data[station_id][item_id].stock
			})
	return markets
