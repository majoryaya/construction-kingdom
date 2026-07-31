# Projectile.gd
# Simple RigidBody2D projectile (bird). Kept minimal for Phase 1/2.
extends RigidBody2D

@export var life_time_after_launch: float = 8.0

var _launched: bool = false

func _ready() -> void:
	sleeping = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not _launched and not sleeping:
		_launched = true
		if life_time_after_launch > 0.0:
			_call_deferred("_start_auto_free_timer")

func _start_auto_free_timer() -> void:
	await get_tree().create_timer(life_time_after_launch).timeout
	if is_inside_tree():
		queue_free()
