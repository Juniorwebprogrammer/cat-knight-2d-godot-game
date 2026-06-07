class_name PatrolState
extends EnemyState

var direction: float = 1.0
var start_x: float = 0.0
@export var patrol_range: float = 150.0  # Distancia a cada lado

func enter() -> void:
	enemy.color_rect.color = Color(0.2, 0.6, 1.0)
	start_x = enemy.global_position.x  # Guardar posición inicial

func update(delta: float) -> void:
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * delta

	enemy.velocity.x = direction * enemy.patrol_speed

	if enemy.global_position.x >= start_x + patrol_range:
		direction = -1.0
		enemy.color_rect.scale.x = -1
	elif enemy.global_position.x <= start_x - patrol_range:
		direction = 1.0
		enemy.color_rect.scale.x = 1

	enemy.move_and_slide()
