# AudioManager.gd
# Usage: attach to a Node and declare as Autoload (AudioManager)
# Central audio manager: play SFX (positional / non-positional), start/stop looping SFX and play music.
extends Node
class_name AudioManager

@export var music_bus_name: String = "Music"
@export var sfx_bus_name: String = "SFX"
@export var master_bus_name: String = "Master"

# Streams assignable in the Autoload inspector
@export var sfx_slingshot_stretch: AudioStream
@export var sfx_bird_launch: AudioStream
@export var sfx_ambience: AudioStream
@export var music_background: AudioStream

var _sfx_player: AudioStreamPlayer
var _music_player: AudioStreamPlayer
var _looping_players: Dictionary = {}

func _ready() -> void:
	randomize()
	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.bus = sfx_bus_name
	add_child(_sfx_player)

	_music_player = AudioStreamPlayer.new()
	_music_player.bus = music_bus_name
	_music_player.stream = music_background
	_music_player.autoplay = false
	_music_player.loop = true
	add_child(_music_player)

# Play a named SFX. If position is provided, a AudioStreamPlayer2D is spawned and freed after playback.
# pitch_variation: fraction variation (0.1 => pitch in [0.9,1.1]).
func play_sfx(name: String, position: Vector2 = null, pitch_variation: float = 0.0) -> void:
	var stream: AudioStream = _get_stream_by_name(name)
	if stream == null:
		push_warning("AudioManager.play_sfx: no stream for '%s'" % name)
		return
	var pitch = 1.0
	if pitch_variation > 0.0:
		pitch = 1.0 + randf_range(-pitch_variation, pitch_variation)
	if position == null:
		_sfx_player.stream = stream
		_sfx_player.pitch_scale = pitch
		_sfx_player.play()
	else:
		var p := AudioStreamPlayer2D.new()
		p.stream = stream
		p.bus = sfx_bus_name
		p.position = position
		p.pitch_scale = pitch
		add_child(p)
		# AudioStreamPlayer2D does not emit "finished" in Godot 4; use a timer to free after length if available
		p.play()
		# schedule free after approximate length if available
		if p.stream is AudioStreamSample:
			var dur = (p.stream as AudioStreamSample).get_length()
			await get_tree().create_timer(dur + 0.1).timeout
		else:
			# fallback small delay
			await get_tree().create_timer(2.0).timeout
		if is_instance_valid(p):
			p.queue_free()

# Start a looping SFX by name. Stored in _looping_players to allow pitch/modulation and stop later.
func start_looping_sfx(name: String) -> void:
	if _looping_players.has(name):
		return
	var stream := _get_stream_by_name(name)
	if stream == null:
		push_warning("AudioManager.start_looping_sfx: no stream for '%s'" % name)
		return
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.bus = sfx_bus_name
	p.loop = true
	add_child(p)
	p.play()
	_looping_players[name] = p

# Stop and free a looping SFX
func stop_looping_sfx(name: String) -> void:
	if not _looping_players.has(name):
		return
	var p := _looping_players[name]
	if is_instance_valid(p):
		p.stop()
		p.queue_free()
	_looping_players.erase(name)

# Adjust pitch of an active looping SFX
func set_loop_pitch(name: String, pitch: float) -> void:
	if _looping_players.has(name):
		var p := _looping_players[name]
		if is_instance_valid(p):
			p.pitch_scale = pitch

# Music control
func play_music(stream: AudioStream = null, loop: bool = true) -> void:
	if stream != null:
		_music_player.stream = stream
	_music_player.loop = loop
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()

# Helper mapping
func _get_stream_by_name(name: String) -> AudioStream:
	match name:
		"slingshot_stretch":
			return sfx_slingshot_stretch
		"bird_launch":
			return sfx_bird_launch
		"ambience":
			return sfx_ambience
		_:
			return null
