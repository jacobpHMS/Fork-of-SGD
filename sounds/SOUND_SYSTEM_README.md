# Sound System Documentation

## Overview
Das Soundsystem ist vollständig vorbereitet und wartet nur auf Audio-Dateien.

## Directory Structure
```
sounds/
├── ui/          # UI sounds (button clicks, menu sounds)
├── sfx/         # Sound effects (mining, engines, collisions)
├── music/       # Music tracks
└── ambient/     # Ambient sounds (space, station interior)
```

## Usage in Code

### Play UI Sound
```gdscript
SoundManager.play_ui_sound("ui_button_click")
```

### Play SFX
```gdscript
SoundManager.play_sfx("sfx_mining_laser")
SoundManager.play_sfx("sfx_cargo_eject", -5.0)  # with volume adjustment
```

### Play Music
```gdscript
SoundManager.play_music("music_space_exploration", true)  # with fade-in
SoundManager.stop_music(true)  # with fade-out
```

### Play Ambient
```gdscript
SoundManager.play_ambient("ambient_space", true)  # looping
```

### Volume Control
```gdscript
# Set category volume (0.0 - 1.0)
SoundManager.set_category_volume(SoundManager.SoundCategory.MUSIC, 0.5)

# Get category volume
var volume = SoundManager.get_category_volume(SoundManager.SoundCategory.SFX)

# Mute category
SoundManager.mute_category(SoundManager.SoundCategory.UI, true)
```

## Registered Sounds

### UI Sounds
- `ui_button_click` - Button click sound
- `ui_button_hover` - Button hover sound
- `ui_menu_open` - Menu opening sound
- `ui_menu_close` - Menu closing sound
- `ui_confirm` - Confirmation sound
- `ui_cancel` - Cancel/back sound

### SFX Sounds
- `sfx_mining_laser` - Mining laser activation
- `sfx_cargo_eject` - Cargo ejection
- `sfx_cargo_pickup` - Cargo pickup
- `sfx_ship_engine` - Ship engine loop
- `sfx_ship_collision` - Collision impact
- `sfx_autopilot_engage` - Autopilot activation
- `sfx_ore_depleted` - Ore fully mined
- `sfx_transfer_complete` - Transfer completed

### Music Tracks
- `music_menu` - Main menu theme
- `music_space_exploration` - Space exploration music
- `music_mining` - Mining activity music
- `music_combat` - Combat music

### Ambient Sounds
- `ambient_space` - Space ambient loop
- `ambient_station` - Station interior ambient
- `ambient_ship_interior` - Ship interior ambient

## Adding New Sounds

1. **Add audio file** to appropriate folder (supports .ogg, .wav, .mp3)
2. **Register in SoundManager.gd:**
   ```gdscript
   # In the sounds dictionary
   "your_sound_name": "res://sounds/category/your_file.ogg"
   ```
3. **Use in code:**
   ```gdscript
   SoundManager.play_sfx("your_sound_name")
   ```

## Audio Format Recommendations
- **Format:** OGG Vorbis (best compression, looping support)
- **UI:** 44.1kHz, Mono, Short (< 0.5s)
- **SFX:** 44.1kHz, Mono/Stereo, Variable length
- **Music:** 44.1kHz, Stereo, Loop points set
- **Ambient:** 44.1kHz, Stereo, Looping

## Categories & Audio Buses
- **Master** - Overall volume control
- **Music** - Background music
- **SFX** - Sound effects
- **UI** - User interface sounds
- **Ambient** - Ambient/environmental sounds
- **Voice** - Voice lines/dialogue (future)

## Settings Persistence
Volume settings are automatically saved to `user://audio_settings.cfg`

## Example Integration

### Button Click
```gdscript
# In button pressed signal
func _on_button_pressed():
    SoundManager.play_ui_sound("ui_button_click")
    # rest of button logic
```

### Mining Start
```gdscript
# In Player.gd when mining starts
func start_mining():
    SoundManager.play_sfx("sfx_mining_laser")
    # mining logic
```

### Scene Music
```gdscript
# In scene _ready()
func _ready():
    SoundManager.play_music("music_space_exploration")
```

## TODO: Add Audio Files
All sound paths are registered but files need to be added to work.
The system will show warnings for missing files but won't crash.
