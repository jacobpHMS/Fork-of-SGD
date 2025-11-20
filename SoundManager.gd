extends Node

## Modular Sound System for Space Mining Game
## Handles all audio playback with categories and volume control

# Sound categories
enum SoundCategory {
	MASTER,
	MUSIC,
	SFX,
	UI,
	AMBIENT,
	VOICE
}

# Audio bus names (must match AudioBusLayout)
const BUS_NAMES = {
	SoundCategory.MASTER: "Master",
	SoundCategory.MUSIC: "Music",
	SoundCategory.SFX: "SFX",
	SoundCategory.UI: "UI",
	SoundCategory.AMBIENT: "Ambient",
	SoundCategory.VOICE: "Voice"
}

# Volume settings (0.0 - 1.0)
var volumes = {
	SoundCategory.MASTER: 1.0,
	SoundCategory.MUSIC: 0.8,
	SoundCategory.SFX: 1.0,
	SoundCategory.UI: 0.9,
	SoundCategory.AMBIENT: 0.7,
	SoundCategory.VOICE: 1.0
}

# Audio players pool for each category
var audio_players = {
	SoundCategory.MUSIC: [],
	SoundCategory.SFX: [],
	SoundCategory.UI: [],
	SoundCategory.AMBIENT: [],
	SoundCategory.VOICE: []
}

# Current music track
var current_music: AudioStreamPlayer = null
var music_fade_duration: float = 2.0

# Sound registry (to be populated with actual sounds)
var sounds = {
	# UI Sounds
	"ui_button_click": "",  # path: res://sounds/ui/button_click.ogg
	"ui_button_hover": "",
	"ui_menu_open": "",
	"ui_menu_close": "",
	"ui_confirm": "",
	"ui_cancel": "",

	# SFX Sounds
	"sfx_mining_laser": "",  # path: res://sounds/sfx/mining_laser.ogg
	"sfx_cargo_eject": "",
	"sfx_cargo_pickup": "",
	"sfx_ship_engine": "",
	"sfx_ship_collision": "",
	"sfx_autopilot_engage": "",
	"sfx_ore_depleted": "",
	"sfx_transfer_complete": "",

	# Music
	"music_menu": "",  # path: res://sounds/music/menu_theme.ogg
	"music_space_exploration": "",
	"music_mining": "",
	"music_combat": "",

	# Ambient
	"ambient_space": "",  # path: res://sounds/ambient/space_ambient.ogg
	"ambient_station": "",
	"ambient_ship_interior": ""
}

func _ready():
	# Load settings
	load_settings()

	# Setup audio buses
	setup_audio_buses()

	# Create audio player pools
	create_audio_player_pools()

	print("SoundManager initialized")

func setup_audio_buses():
	"""Setup audio bus volumes from settings"""
	for category in volumes.keys():
		set_category_volume(category, volumes[category])

func create_audio_player_pools():
	"""Create pools of audio players for each category"""
	# Create multiple players for SFX (for overlapping sounds)
	for i in range(8):
		var player = AudioStreamPlayer.new()
		player.bus = BUS_NAMES[SoundCategory.SFX]
		add_child(player)
		audio_players[SoundCategory.SFX].append(player)

	# Create players for UI
	for i in range(4):
		var player = AudioStreamPlayer.new()
		player.bus = BUS_NAMES[SoundCategory.UI]
		add_child(player)
		audio_players[SoundCategory.UI].append(player)

	# Create music player
	var music_player = AudioStreamPlayer.new()
	music_player.bus = BUS_NAMES[SoundCategory.MUSIC]
	add_child(music_player)
	audio_players[SoundCategory.MUSIC].append(music_player)

	# Create ambient players
	for i in range(2):
		var player = AudioStreamPlayer.new()
		player.bus = BUS_NAMES[SoundCategory.AMBIENT]
		add_child(player)
		audio_players[SoundCategory.AMBIENT].append(player)

	# Create voice player
	var voice_player = AudioStreamPlayer.new()
	voice_player.bus = BUS_NAMES[SoundCategory.VOICE]
	add_child(voice_player)
	audio_players[SoundCategory.VOICE].append(voice_player)

func play_sound(sound_name: String, category: SoundCategory = SoundCategory.SFX, volume_db: float = 0.0, pitch_scale: float = 1.0):
	"""Play a sound effect"""
	# Check if sound exists
	if not sounds.has(sound_name) or sounds[sound_name] == "":
		push_warning("Sound not found or not implemented: " + sound_name)
		return

	# Get available player
	var player = get_available_player(category)
	if not player:
		push_warning("No available audio player for category: " + str(category))
		return

	# Load and play sound
	var sound_path = sounds[sound_name]
	if not FileAccess.file_exists(sound_path):
		push_warning("Sound file not found: " + sound_path)
		return

	var stream = load(sound_path)
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.play()

func play_ui_sound(sound_name: String):
	"""Shortcut for playing UI sounds"""
	play_sound(sound_name, SoundCategory.UI)

func play_sfx(sound_name: String, volume_db: float = 0.0):
	"""Shortcut for playing SFX sounds"""
	play_sound(sound_name, SoundCategory.SFX, volume_db)

func play_music(music_name: String, fade_in: bool = true):
	"""Play music track with optional fade"""
	if not sounds.has(music_name) or sounds[music_name] == "":
		push_warning("Music not found: " + music_name)
		return

	var music_path = sounds[music_name]
	if not FileAccess.file_exists(music_path):
		push_warning("Music file not found: " + music_path)
		return

	# Fade out current music
	if current_music and current_music.playing:
		if fade_in:
			fade_out_music(current_music)
		else:
			current_music.stop()

	# Get music player
	var player = audio_players[SoundCategory.MUSIC][0]
	var stream = load(music_path)
	player.stream = stream
	player.volume_db = -80.0 if fade_in else 0.0
	player.play()

	current_music = player

	# Fade in
	if fade_in:
		fade_in_music(player)

func fade_in_music(player: AudioStreamPlayer):
	"""Fade in music"""
	var tween = create_tween()
	tween.tween_property(player, "volume_db", 0.0, music_fade_duration)

func fade_out_music(player: AudioStreamPlayer):
	"""Fade out music"""
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80.0, music_fade_duration)
	tween.tween_callback(player.stop)

func stop_music(fade_out: bool = true):
	"""Stop current music"""
	if current_music:
		if fade_out:
			fade_out_music(current_music)
		else:
			current_music.stop()
		current_music = null

func play_ambient(ambient_name: String, loop: bool = true):
	"""Play ambient sound"""
	if not sounds.has(ambient_name) or sounds[ambient_name] == "":
		push_warning("Ambient sound not found: " + ambient_name)
		return

	var ambient_path = sounds[ambient_name]
	if not FileAccess.file_exists(ambient_path):
		push_warning("Ambient file not found: " + ambient_path)
		return

	var player = audio_players[SoundCategory.AMBIENT][0]
	var stream = load(ambient_path)
	player.stream = stream
	player.play()

	# Loop if needed (assuming stream supports it)
	if stream is AudioStreamOggVorbis:
		stream.loop = loop

func get_available_player(category: SoundCategory) -> AudioStreamPlayer:
	"""Get an available audio player from pool"""
	if not audio_players.has(category):
		return null

	var players = audio_players[category]

	# Find non-playing player
	for player in players:
		if not player.playing:
			return player

	# Return first player (will interrupt it)
	return players[0] if players.size() > 0 else null

func set_category_volume(category: SoundCategory, volume: float):
	"""Set volume for a category (0.0 - 1.0)"""
	volume = clamp(volume, 0.0, 1.0)
	volumes[category] = volume

	# Convert to decibels (-80 to 0 dB)
	var volume_db = linear_to_db(volume) if volume > 0.0 else -80.0

	# Set bus volume
	var bus_name = BUS_NAMES[category]
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx >= 0:
		AudioServer.set_bus_volume_db(bus_idx, volume_db)

	save_settings()

func get_category_volume(category: SoundCategory) -> float:
	"""Get volume for a category (0.0 - 1.0)"""
	return volumes.get(category, 1.0)

func mute_category(category: SoundCategory, mute: bool):
	"""Mute/unmute a category"""
	var bus_name = BUS_NAMES[category]
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx >= 0:
		AudioServer.set_bus_mute(bus_idx, mute)

func save_settings():
	"""Save audio settings"""
	var config = ConfigFile.new()

	for category in volumes.keys():
		config.set_value("audio", str(category), volumes[category])

	config.save("user://audio_settings.cfg")

func load_settings():
	"""Load audio settings"""
	var config = ConfigFile.new()
	var err = config.load("user://audio_settings.cfg")

	if err == OK:
		for category in volumes.keys():
			if config.has_section_key("audio", str(category)):
				volumes[category] = config.get_value("audio", str(category))

func register_sound(sound_name: String, sound_path: String):
	"""Register a sound file (for dynamic loading)"""
	sounds[sound_name] = sound_path

func linear_to_db(linear: float) -> float:
	"""Convert linear volume to decibels"""
	return 20.0 * log(linear) / log(10.0) if linear > 0.0 else -80.0
