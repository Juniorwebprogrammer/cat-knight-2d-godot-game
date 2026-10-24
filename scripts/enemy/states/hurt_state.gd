class_name HurtState
extends EnemyState

@export var hurt_duration: float = 0.3

var _timer: float = 0.0

func enter() -> void:
	_timer = hurt_duration
	enemy.animated_sprite.play("Hurt")

func update(delta: float) -> void:
	_apply_gravity(delta)
	_apply_friction(delta)
	enemy.move_and_slide()
	_tick_recovery(delta)


func _apply_gravity(delta: float) -> void:
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * delta


func _apply_friction(delta: float) -> void:
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, 600.0 * delta)


func _tick_recovery(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		state_machine.change_state("Patrol")
