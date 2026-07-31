# AudioManager.gd
# Usage: attach to a Node and declare as Autoload (AudioManager)
# Central audio manager: play SFX (positional / non-positional), start/stop looping SFX and play music.
extends Node
class_name AudioManager

@export var music_bus_name: String = "Music"
@export var sfx_bus_name: String = "SFX"
@export var master_bus_name: String = "Master"

@export var sfx_slingshot_stretch: AudioStream
@export var sfx_bird_launch: AudioStream
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
		p.connect("finished", Callable(p, "queue_free"))
		p.play()

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

func stop_looping_sfx(name: String) -> void:
	if not _looping_players.has(name):
		return
	var p := _looping_players[name]
	if is_instance_valid(p):
		p.stop()
		p.queue_free()
	_looping_players.erase(name)

func set_loop_pitch(name: String, pitch: float) -> void:
	if _looping_players.has(name):
		var p := _looping_players[name]
		if is_instance_valid(p):
			p.pitch_scale = pitch

func play_music(stream: AudioStream = null, loop: bool = true) -> void:
	if stream != null:
		_music_player.stream = stream
	_music_player.loop = loop
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()

func _get_stream_by_name(name: String) -> AudioStream:
	match name:
		"slingshot_stretch":
			return sfx_slingshot_stretch
		"bird_launch":
			return sfx_bird_launch
		_:
			return null
