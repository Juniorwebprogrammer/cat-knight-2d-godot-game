class_name PatrolState
extends EnemyState

@export var patrol_range: float = 150.0  # Distancia a cada lado

var direction: float = 1.0
var start_x: float = 0.0

func enter() -> void:
	start_x = enemy.home_x
	direction = enemy.get_facing_direction()

func update(delta: float) -> void:
	_change_animation()
	_check_if_enemy_is_on_floor(delta)
	_patrol()
	_check_for_player()
	enemy.move_and_slide()

func _check_for_player() -> void:
	if enemy.is_player_detected():
		state_machine.change_state("Pursue")

func _change_animation() -> void:
	enemy.animated_sprite.play("Walk")

func _check_if_enemy_is_on_floor(delta: float) -> void:
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * delta
	enemy.velocity.x = direction * enemy.patrol_speed

func _patrol() -> void:
	if enemy.global_position.x >= start_x + patrol_range:
		direction = -1.0
		enemy.animated_sprite.flip_h = true
	elif enemy.global_position.x <= start_x - patrol_range:
		direction = 1.0
		enemy.animated_sprite.flip_h = false
	enemy.face_direction(direction)

func _direction_towards_patrol_zone() -> float:
	var offset := enemy.global_position.x - start_x
	if absf(offset) > patrol_range:
		return -signf(offset)
	return enemy.get_facing_direction()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		state_machine.change_state("Pursue")
		
