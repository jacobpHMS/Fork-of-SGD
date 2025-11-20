extends Area2D

# Crate data
var item_id: String = ""
var item_amount: float = 0.0
var despawn_timer: float = 60.0  # Seconds until despawn

# Visual representation
var sprite: Sprite2D = null
var label: Label = null

func _ready():
	# Add to group
	add_to_group("cargo_crates")

	# Setup collision
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(20, 20)
	collision.shape = shape
	add_child(collision)

	# Create visual (simple colored rectangle)
	sprite = Sprite2D.new()
	# Create a simple texture programmatically
	var img = Image.create(20, 20, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.8, 0.6, 0.2, 1.0))  # Orange color for crate
	var texture = ImageTexture.create_from_image(img)
	sprite.texture = texture
	add_child(sprite)

	# Add label showing item info
	label = Label.new()
	label.position = Vector2(-30, -30)
	label.add_theme_font_size_override("font_size", 10)
	label.text = item_id
	add_child(label)

	# Connect area signals
	body_entered.connect(_on_body_entered)

func _process(delta):
	# Countdown despawn timer
	despawn_timer -= delta
	if despawn_timer <= 0:
		queue_free()

	# Update label with timer
	if label:
		label.text = "%s\n%.0fs" % [item_id, despawn_timer]

func set_cargo_data(id: String, amount: float):
	"""Set the cargo data for this crate"""
	item_id = id
	item_amount = amount

	if label:
		label.text = item_id

func _on_body_entered(body):
	"""When player ship collides with crate"""
	if body.is_in_group("player"):
		# Try to add cargo to player
		if body.has_method("add_to_cargo"):
			body.add_to_cargo(item_id, item_amount)
			print("Picked up: ", item_id, " x ", item_amount)

			# Emit signal for UI updates (History Log)
			if body.has_signal("cargo_crate_picked_up"):
				body.cargo_crate_picked_up.emit(item_id, item_amount)

			queue_free()  # Remove crate after pickup

func get_crate_info() -> Dictionary:
	"""Get crate information"""
	return {
		"item_id": item_id,
		"amount": item_amount,
		"despawn_in": despawn_timer
	}
