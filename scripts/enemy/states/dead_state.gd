class_name DeadState
extends EnemyState

@export var death_duration: float = 0.5

var death_timer: float = 0.0

func enter() -> void:
	print(">>> ENEMY: Dead")
	death_timer = death_duration
	enemy.color_rect.color = Color(0.3, 0.3, 0.3)  # Gris
	# Desactivar hurtbox para no recibir más daño
	enemy.hurtbox.monitoring = false
	enemy.hurtbox.monitorable = false
	# Detener movimiento
	enemy.velocity = Vector2.ZERO

func update(delta: float) -> void:
	# Gravedad para que caiga si está en el aire
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * delta
	enemy.velocity.x = 0
	enemy.move_and_slide()

	# Esperar y desaparecer
	death_timer -= delta
	if death_timer <= 0:
		enemy.queue_free()
