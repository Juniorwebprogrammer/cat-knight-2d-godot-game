class_name PatrolState
extends EnemyState

@export var patrol_range: float = 150.0

var direction: float = 1.0
var start_x: float = 0.0


func enter() -> void:
	start_x = enemy.home_x
	direction = enemy.get_facing_direction()


func update(delta: float) -> void:
	_change_animation()
	_apply_gravity(delta)
	_patrol()
	_apply_patrol_velocity()
	enemy.move_and_slide()
	_turn_if_blocked_by_wall()
	_check_for_player()


func _change_animation() -> void:
	enemy.animated_sprite.play("Walk")


func _apply_gravity(delta: float) -> void:
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * delta


func _apply_patrol_velocity() -> void:
	enemy.velocity.x = direction * enemy.patrol_speed


func _patrol() -> void:
	if enemy.global_position.x >= start_x + patrol_range:
		direction = -1.0
	elif enemy.global_position.x <= start_x - patrol_range:
		direction = 1.0
	enemy.face_direction(direction)


func _turn_if_blocked_by_wall() -> void:
	if not enemy.is_on_wall():
		return
	# La normal de la pared apunta hacia fuera, así que siempre nos aleja de ella
	direction = signf(enemy.get_wall_normal().x)
	enemy.face_direction(direction)


func _check_for_player() -> void:
	if enemy.is_player_detected():
		state_machine.change_state("Pursue")
