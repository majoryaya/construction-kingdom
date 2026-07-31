# Slingshot.gd
# Drag-and-release slingshot with clamped pull, trajectory prediction and audio hooks.
# Phase 2 improvements: trajectory computed from expected impulse and projectile mass,
# and AudioManager ambience/music integration.
extends Node2D

@export var anchor_node_path: NodePath = NodePath("Anchor")
@export var projectile_scene: PackedScene
@export var max_pull_distance: float = 200.0
@export var launch_strength: float = 12.0
@export var stretch_pitch_variation_max: float = 0.6
@export var trajectory_points: int = 50
@export var trajectory_time_step: float = 0.06

var _anchor: Position2D
var _current_projectile: RigidBody2D = null
var _dragging: bool = false

func _ready() -> void:
	_anchor = get_node_or_null(anchor_node_path) as Position2D
	if _anchor == null:
		push_error("Slingshot: anchor node not found. Check anchor_node_path.")
	# Start background music and ambience if available
	if Engine.has_singleton("AudioManager"):
		AudioManager.play_music()
		AudioManager.start_looping_sfx("ambience")
	_spawn_projectile()

func _spawn_projectile() -> void:
	if projectile_scene == null:
		push_error("Slingshot: projectile_scene is not assigned.")
		return
	var inst := projectile_scene.instantiate()
	add_child(inst)
	_current_projectile = inst as RigidBody2D
	_current_projectile.global_position = _anchor.global_position
	_current_projectile.sleeping = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if _current_projectile != null and event.position.distance_to(_anchor.global_position) <= max_pull_distance + 20:
				_dragging = true
				if Engine.has_singleton("AudioManager"):
					AudioManager.start_looping_sfx("slingshot_stretch")
		else:
			if _dragging:
				_perform_launch(event.position)
				_dragging = false
				if Engine.has_singleton("AudioManager"):
					AudioManager.stop_looping_sfx("slingshot_stretch")
	if event is InputEventMouseMotion and _dragging:
		_update_pull(event.position)

func _update_pull(mouse_pos: Vector2) -> void:
	var rel = mouse_pos - _anchor.global_position
	var clamped = rel.clamped(max_pull_distance)
	if _current_projectile != null:
		_current_projectile.global_position = _anchor.global_position + clamped
	# update stretch pitch
	var pull_ratio = clamped.length() / max_pull_distance
	var pitch = 1.0 + pull_ratio * stretch_pitch_variation_max
	if Engine.has_singleton("AudioManager"):
		AudioManager.set_loop_pitch("slingshot_stretch", pitch)
	_update_rubber_visual(clamped)
	_update_trajectory(clamped)

func _update_rubber_visual(clamped: Vector2) -> void:
	var rubber = $RubberVisual if has_node("RubberVisual") else null
	if rubber:
		rubber.clear_points()
		rubber.add_point(_anchor.position)
		rubber.add_point(global_to_local(_anchor.global_position + clamped))

func _update_trajectory(clamped: Vector2) -> void:
	# We compute the expected initial velocity based on the impulse we will apply and the projectile mass.
	# Impulse (J) we apply at launch: J = (-clamped) * launch_strength * mass
	# Resulting initial velocity v0 = J / mass = (-clamped) * launch_strength
	# This simplifies mass out of the equation, but we compute it explicitly for clarity and future changes.
	var traj = $Trajectory if has_node("Trajectory") else null
	if traj == null:
		return
	# compute impulse and v0
	var maybe_mass = 1.0
	if _current_projectile != null:
		maybe_mass = _current_projectile.mass
	var impulse = (-clamped) * launch_strength * maybe_mass
	var v0 = Vector2.ZERO
	if maybe_mass != 0.0:
		v0 = impulse / maybe_mass
	# gravity from project settings
	var g_val = ProjectSettings.get_setting("physics/2d/default_gravity")
	var gravity = Vector2(0, g_val)
	var points: Array[Vector2] = []
	for i in trajectory_points:
		var t = i * trajectory_time_step
		# s(t) = anchor + v0 * t + 0.5 * g * t^2
		var pos = _anchor.global_position + v0 * t + 0.5 * gravity * t * t
		points.append(global_to_local(pos))
	traj.points = points

func _perform_launch(mouse_pos: Vector2) -> void:
	if _current_projectile == null:
		return
	var rel = mouse_pos - _anchor.global_position
	var clamped = rel.clamped(max_pull_distance)
	# Impulse applied: (-clamped) * launch_strength * mass
	var mass = _current_projectile.mass
	var impulse_vec = (-clamped) * launch_strength * mass
	_current_projectile.sleeping = false
	_current_projectile.apply_central_impulse(impulse_vec)
	if Engine.has_singleton("AudioManager"):
		AudioManager.play_sfx("bird_launch", _current_projectile.global_position, 0.12)
	# stop ambience stretch visual and clear trajectory
	_current_projectile = null
	if has_node("Trajectory"):
		$Trajectory.points = []
	await get_tree().create_timer(0.7).timeout
	_spawn_projectile()
