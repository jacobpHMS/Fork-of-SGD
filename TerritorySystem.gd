extends Node
class_name TerritorySystem
## Territory & Sovereignty System (EVE/X4-inspired)

signal territory_claimed(system_id: String, owner_id: String)
signal territory_contested(system_id: String, attacker_id: String)
signal siege_started(system_id: String, attacker_id: String, duration: float)
signal territory_lost(system_id: String, previous_owner: String)

# System ownership: system_id -> OwnershipData
var system_ownership: Dictionary = {}

class OwnershipData:
	var system_id: String
	var owner_id: String  # Corp/Alliance ID
	var control_points: int = 100
	var tax_rate: float = 0.05
	var resource_bonus: float = 1.0
	var siege_timer: float = 0.0
	var is_contested: bool = false

	func _init(p_sys: String, p_owner: String):
		system_id = p_sys
		owner_id = p_owner

func _ready():
	print("🏛️ TerritorySystem: Ready")

func claim_system(system_id: String, owner_id: String) -> bool:
	"""Claim an unclaimed system"""
	if system_ownership.has(system_id):
		return false

	var ownership = OwnershipData.new(system_id, owner_id)
	system_ownership[system_id] = ownership
	territory_claimed.emit(system_id, owner_id)
	print("🏛️ Territory claimed: %s → %s" % [system_id, owner_id])
	return true

func start_siege(system_id: String, attacker_id: String):
	"""Start siege on enemy territory"""
	if not system_ownership.has(system_id):
		return

	var ownership = system_ownership[system_id]
	ownership.is_contested = true
	ownership.siege_timer = 86400.0  # 24h timer

	siege_started.emit(system_id, attacker_id, 86400.0)
	print("⚔️ Siege started: %s attacking %s (24h timer)" % [attacker_id, system_id])

func get_tax_income(system_id: String) -> float:
	"""Calculate tax income from system"""
	if not system_ownership.has(system_id):
		return 0.0

	var ownership = system_ownership[system_id]
	return 10000.0 * ownership.tax_rate  # Base income * tax

func get_owner(system_id: String) -> String:
	"""Get system owner"""
	if system_ownership.has(system_id):
		return system_ownership[system_id].owner_id
	return ""
