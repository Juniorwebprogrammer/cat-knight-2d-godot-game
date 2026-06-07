class_name HurtState
extends EnemyState

@export var hurt_duration: float = 0.4

var hurt_timer: float = 0.0

func enter() -> void:
	print(">>> ENEMY: Hurt")
	hurt_timer = hurt_duration
	# Flash rojo
	enemy.color_rect.color = Color.RED

func update(delta: float) -> void:
	# Aplicar gravedad y knockback
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * delta

	# Frenar el knockback gradualmente
	enemy.velocity.x = lerpf(enemy.velocity.x, 0, 0.2)
	enemy.move_and_slide()

	# Contar tiempo de hurt
	hurt_timer -= delta
	if hurt_timer <= 0:
		enemy.state_machine.change_state("Patrol")
