extends Window
class_name MarketWindow
## MarketWindow - EVE Online-style market interface
##
## Features:
## - Browse all items with prices
## - See price history charts
## - View market trends
## - Place buy/sell orders
## - Compare prices across stations
## - See current stock levels
## - Filter by category

# ============================================================================
# SIGNALS
# ============================================================================

signal item_purchased(item_id: String, amount: float, total_cost: float)
signal item_sold(item_id: String, amount: float, total_payout: float)

# ============================================================================
# STATE
# ============================================================================

var current_station_id: String = "STATION_JITA"
var selected_item_id: String = ""
var player_id: String = "PLAYER"
var theme: SciFiTheme = null

# UI References
var item_list: ItemList = null
var price_label: Label = null
var stock_label: Label = null
var trend_label: Label = null
var amount_spinbox: SpinBox = null
var total_cost_label: Label = null
var buy_button: Button = null
var sell_button: Button = null
var price_chart_container: PanelContainer = null
var station_selector: OptionButton = null
var category_filter: OptionButton = null

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	theme = SciFiTheme.new()

	# Window setup
	title = "💰 Commodity Exchange - " + current_station_id
	size = Vector2i(1200, 800)
	min_size = Vector2i(800, 600)
	position = Vector2i(100, 50)

	# Build UI
	_build_ui()

	# Populate item list
	_populate_item_list()

	# Connect to MarketSystem signals
	if MarketSystem:
		MarketSystem.price_changed.connect(_on_market_price_changed)
		MarketSystem.stock_level_changed.connect(_on_stock_level_changed)
		MarketSystem.market_trend_changed.connect(_on_trend_changed)

	print("✅ MarketWindow initialized")

# ============================================================================
# UI BUILDING
# ============================================================================

func _build_ui():
	"""Build complete market UI"""
	var main_vbox = VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(main_vbox)

	# Header
	var header = _create_header()
	main_vbox.add_child(header)

	main_vbox.add_child(theme.create_separator())

	# Main content (HSplit: Item list | Details)
	var hsplit = HSplitContainer.new()
	hsplit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(hsplit)

	# Left: Item list + filters
	var left_panel = _create_item_list_panel()
	left_panel.custom_minimum_size = Vector2(400, 0)
	hsplit.add_child(left_panel)

	# Right: Item details + trading
	var right_panel = _create_details_panel()
	hsplit.add_child(right_panel)

func _create_header() -> HBoxContainer:
	"""Create header with station selector"""
	var header = HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)

	# Title
	var title_label = Label.new()
	title_label.text = "💰 COMMODITY EXCHANGE"
	theme.apply_title_style(title_label, theme.COLOR_ACCENT_CYAN)
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title_label)

	# Station selector
	var station_label = Label.new()
	station_label.text = "Station:"
	theme.apply_body_style(station_label)
	header.add_child(station_label)

	station_selector = OptionButton.new()
	station_selector.add_item("STATION_JITA")
	station_selector.add_item("STATION_AMARR")
	station_selector.add_item("STATION_DODIXIE")
	station_selector.add_item("STATION_RENS")
	station_selector.selected = 0
	station_selector.item_selected.connect(_on_station_changed)
	theme.apply_button_style(station_selector, theme.COLOR_ACCENT_CYAN)
	header.add_child(station_selector)

	# Close button
	var close_btn = Button.new()
	close_btn.text = "✕ Close"
	close_btn.custom_minimum_size = Vector2(80, 40)
	theme.apply_button_style(close_btn, theme.COLOR_STATUS_DANGER)
	close_btn.pressed.connect(hide)
	header.add_child(close_btn)

	return header

func _create_item_list_panel() -> VBoxContainer:
	"""Create left panel with item list"""
	var vbox = VBoxContainer.new()

	# Category filter
	var filter_hbox = HBoxContainer.new()
	vbox.add_child(filter_hbox)

	var filter_label = Label.new()
	filter_label.text = "Category:"
	theme.apply_small_style(filter_label)
	filter_hbox.add_child(filter_label)

	category_filter = OptionButton.new()
	category_filter.add_item("All")
	category_filter.add_item("Ores")
	category_filter.add_item("Materials")
	category_filter.add_item("Components")
	category_filter.add_item("Weapons")
	category_filter.add_item("Modules")
	category_filter.selected = 0
	category_filter.item_selected.connect(_on_category_filter_changed)
	category_filter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	filter_hbox.add_child(category_filter)

	# Item list
	item_list = ItemList.new()
	item_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	item_list.item_selected.connect(_on_item_selected)
	vbox.add_child(item_list)

	return vbox

func _create_details_panel() -> VBoxContainer:
	"""Create right panel with item details and trading"""
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)

	# Item info panel
	var info_panel = _create_item_info_panel()
	vbox.add_child(info_panel)

	# Price chart panel
	price_chart_container = _create_price_chart_panel()
	price_chart_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(price_chart_container)

	# Trading panel
	var trading_panel = _create_trading_panel()
	vbox.add_child(trading_panel)

	return vbox

func _create_item_info_panel() -> PanelContainer:
	"""Create item info display"""
	var panel = PanelContainer.new()
	var panel_style = theme.create_panel_style(SciFiTheme.PanelStyle.TACTICAL, SciFiTheme.BorderGlow.SUBTLE)
	panel.add_theme_stylebox_override("panel", panel_style)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	# Item name
	var item_name_label = Label.new()
	item_name_label.name = "ItemNameLabel"
	item_name_label.text = "Select an item"
	theme.apply_header_style(item_name_label)
	item_name_label.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	vbox.add_child(item_name_label)

	# Market data grid
	var grid = GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 8)
	vbox.add_child(grid)

	# Price
	var price_title = Label.new()
	price_title.text = "Current Price:"
	theme.apply_small_style(price_title)
	grid.add_child(price_title)

	price_label = Label.new()
	price_label.text = "--- credits"
	theme.apply_body_style(price_label)
	price_label.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	grid.add_child(price_label)

	# Stock
	var stock_title = Label.new()
	stock_title.text = "Available Stock:"
	theme.apply_small_style(stock_title)
	grid.add_child(stock_title)

	stock_label = Label.new()
	stock_label.text = "---"
	theme.apply_body_style(stock_label)
	grid.add_child(stock_label)

	# Trend
	var trend_title = Label.new()
	trend_title.text = "Market Trend:"
	theme.apply_small_style(trend_title)
	grid.add_child(trend_title)

	trend_label = Label.new()
	trend_label.text = "STABLE"
	theme.apply_body_style(trend_label)
	grid.add_child(trend_label)

	return panel

func _create_price_chart_panel() -> PanelContainer:
	"""Create price history chart panel"""
	var panel = PanelContainer.new()
	var panel_style = theme.create_panel_style(SciFiTheme.PanelStyle.STANDARD, SciFiTheme.BorderGlow.SUBTLE)
	panel.add_theme_stylebox_override("panel", panel_style)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	var title = Label.new()
	title.text = "📈 Price History (24h)"
	theme.apply_header_style(title)
	vbox.add_child(title)

	# Placeholder for chart (would need GraphPlot or custom drawing)
	var chart_label = Label.new()
	chart_label.text = "Price chart visualization\n(Would show 24h price history here)"
	chart_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	chart_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	chart_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	theme.apply_small_style(chart_label)
	chart_label.add_theme_color_override("font_color", theme.COLOR_TEXT_DIM)
	vbox.add_child(chart_label)

	return panel

func _create_trading_panel() -> PanelContainer:
	"""Create buy/sell trading panel"""
	var panel = PanelContainer.new()
	var panel_style = theme.create_panel_style(SciFiTheme.PanelStyle.ENGINEERING, SciFiTheme.BorderGlow.SUBTLE)
	panel.add_theme_stylebox_override("panel", panel_style)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)

	var title = Label.new()
	title.text = "💱 Trade"
	theme.apply_header_style(title)
	vbox.add_child(title)

	# Amount selector
	var amount_hbox = HBoxContainer.new()
	amount_hbox.add_theme_constant_override("separation", 8)
	vbox.add_child(amount_hbox)

	var amount_label = Label.new()
	amount_label.text = "Amount:"
	theme.apply_body_style(amount_label)
	amount_label.custom_minimum_size = Vector2(80, 0)
	amount_hbox.add_child(amount_label)

	amount_spinbox = SpinBox.new()
	amount_spinbox.min_value = 1
	amount_spinbox.max_value = 1000000
	amount_spinbox.value = 100
	amount_spinbox.step = 100
	amount_spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	amount_spinbox.value_changed.connect(_on_amount_changed)
	amount_hbox.add_child(amount_spinbox)

	# Total cost
	total_cost_label = Label.new()
	total_cost_label.text = "Total: 0 credits"
	total_cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	theme.apply_body_style(total_cost_label)
	total_cost_label.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	vbox.add_child(total_cost_label)

	# Buttons
	var button_hbox = HBoxContainer.new()
	button_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	button_hbox.add_theme_constant_override("separation", 12)
	vbox.add_child(button_hbox)

	buy_button = Button.new()
	buy_button.text = "📥 BUY"
	buy_button.custom_minimum_size = Vector2(150, 45)
	theme.apply_button_style(buy_button, theme.COLOR_STATUS_ACTIVE)
	buy_button.pressed.connect(_on_buy_pressed)
	buy_button.disabled = true
	button_hbox.add_child(buy_button)

	sell_button = Button.new()
	sell_button.text = "📤 SELL"
	sell_button.custom_minimum_size = Vector2(150, 45)
	theme.apply_button_style(sell_button, theme.COLOR_STATUS_WARNING)
	sell_button.pressed.connect(_on_sell_pressed)
	sell_button.disabled = true
	button_hbox.add_child(sell_button)

	return panel

# ============================================================================
# DATA POPULATION
# ============================================================================

func _populate_item_list():
	"""Populate item list with all available items"""
	if not item_list:
		return

	item_list.clear()

	if not MarketSystem:
		return

	# Get all items from DatabaseManager
	var all_item_ids = DatabaseManager.get_all_item_ids() if DatabaseManager else []

	# Filter by category
	var category_index = category_filter.selected if category_filter else 0
	var category_prefix = _get_category_prefix(category_index)

	for item_id in all_item_ids:
		# Apply category filter
		if category_prefix != "" and not item_id.begins_with(category_prefix):
			continue

		var price = MarketSystem.get_current_price(item_id, current_station_id)
		var stock = MarketSystem.get_stock(item_id, current_station_id)

		var display_text = "%s - %.2f CR (Stock: %.0f)" % [item_id, price, stock]
		item_list.add_item(display_text)
		item_list.set_item_metadata(item_list.get_item_count() - 1, item_id)

func _get_category_prefix(index: int) -> String:
	"""Get item ID prefix for category filter"""
	match index:
		0: return ""  # All
		1: return "ORE_"
		2: return "MAT_"
		3: return "COMP_"
		4: return "WEP_"
		5: return "MOD_"
	return ""

func _update_item_details():
	"""Update item details panel"""
	if selected_item_id == "":
		return

	if not MarketSystem:
		return

	# Update item name
	var item_name_label = get_node_or_null("VBoxContainer/HSplitContainer/VBoxContainer/PanelContainer/VBoxContainer/ItemNameLabel")
	if item_name_label:
		item_name_label.text = selected_item_id.capitalize()

	# Update price
	var price = MarketSystem.get_current_price(selected_item_id, current_station_id)
	if price_label:
		price_label.text = "%.2f credits" % price

	# Update stock
	var stock = MarketSystem.get_stock(selected_item_id, current_station_id)
	if stock_label:
		stock_label.text = "%.0f units" % stock

	# Update trend
	var trend = MarketSystem.get_market_trend(selected_item_id)
	if trend_label:
		var trend_text = MarketSystem.TrendDirection.keys()[trend]
		var trend_color = _get_trend_color(trend)
		trend_label.text = trend_text
		trend_label.add_theme_color_override("font_color", trend_color)

	# Enable buttons
	if buy_button:
		buy_button.disabled = false
	if sell_button:
		sell_button.disabled = false

	# Update total cost
	_update_total_cost()

func _get_trend_color(trend: int) -> Color:
	"""Get color for market trend"""
	match trend:
		MarketSystem.TrendDirection.CRASHING:
			return Color.RED
		MarketSystem.TrendDirection.DECLINING:
			return Color.ORANGE_RED
		MarketSystem.TrendDirection.STABLE:
			return Color.WHITE
		MarketSystem.TrendDirection.RISING:
			return Color.LIGHT_GREEN
		MarketSystem.TrendDirection.SURGING:
			return Color.GREEN
	return Color.WHITE

func _update_total_cost():
	"""Update total cost display"""
	if selected_item_id == "" or not amount_spinbox or not total_cost_label:
		return

	var price = MarketSystem.get_current_price(selected_item_id, current_station_id)
	var amount = amount_spinbox.value
	var total = price * amount

	total_cost_label.text = "Total: %.2f credits" % total

# ============================================================================
# CALLBACKS
# ============================================================================

func _on_item_selected(index: int):
	"""Handle item selection"""
	selected_item_id = item_list.get_item_metadata(index)
	_update_item_details()

func _on_amount_changed(_value: float):
	"""Handle amount changed"""
	_update_total_cost()

func _on_buy_pressed():
	"""Handle buy button"""
	if selected_item_id == "" or not amount_spinbox:
		return

	var amount = amount_spinbox.value
	var success = MarketSystem.buy_item(selected_item_id, amount, player_id, current_station_id)

	if success:
		var price = MarketSystem.get_current_price(selected_item_id, current_station_id)
		var total_cost = price * amount
		item_purchased.emit(selected_item_id, amount, total_cost)
		print("✅ Purchase successful: %.0f %s for %.2f credits" % [amount, selected_item_id, total_cost])

		# Refresh display
		_update_item_details()
		_populate_item_list()
	else:
		print("❌ Purchase failed")

func _on_sell_pressed():
	"""Handle sell button"""
	if selected_item_id == "" or not amount_spinbox:
		return

	var amount = amount_spinbox.value
	var success = MarketSystem.sell_item(selected_item_id, amount, player_id, current_station_id)

	if success:
		var price = MarketSystem.get_current_price(selected_item_id, current_station_id)
		var total_payout = price * amount
		item_sold.emit(selected_item_id, amount, total_payout)
		print("✅ Sale successful: %.0f %s for %.2f credits" % [amount, selected_item_id, total_payout])

		# Refresh display
		_update_item_details()
		_populate_item_list()
	else:
		print("❌ Sale failed")

func _on_station_changed(index: int):
	"""Handle station selection changed"""
	current_station_id = station_selector.get_item_text(index)
	title = "💰 Commodity Exchange - " + current_station_id

	# Refresh all data
	_populate_item_list()
	if selected_item_id != "":
		_update_item_details()

func _on_category_filter_changed(_index: int):
	"""Handle category filter changed"""
	_populate_item_list()

# ============================================================================
# MARKET SYSTEM CALLBACKS
# ============================================================================

func _on_market_price_changed(item_id: String, station_id: String, _old_price: float, _new_price: float):
	"""Handle market price change"""
	if station_id == current_station_id:
		_populate_item_list()
		if item_id == selected_item_id:
			_update_item_details()

func _on_stock_level_changed(item_id: String, station_id: String, _stock: float):
	"""Handle stock level change"""
	if station_id == current_station_id:
		_populate_item_list()
		if item_id == selected_item_id:
			_update_item_details()

func _on_trend_changed(item_id: String, _trend: int):
	"""Handle trend change"""
	if item_id == selected_item_id:
		_update_item_details()

# ============================================================================
# PUBLIC API
# ============================================================================

func set_station(station_id: String):
	"""Set current station"""
	current_station_id = station_id
	if station_selector:
		for i in range(station_selector.get_item_count()):
			if station_selector.get_item_text(i) == station_id:
				station_selector.selected = i
				break

	_populate_item_list()

func set_player(p_player_id: String):
	"""Set player ID"""
	player_id = p_player_id
