class_name DeadState
extends EnemyState


func enter() -> void:
	_disable_collisions()
	enemy.velocity.x = 0.0
	enemy.animated_sprite.play("Death")
	enemy.animated_sprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)


func update(delta: float) -> void:
	_apply_gravity(delta)
	enemy.move_and_slide()


func _disable_collisions() -> void:
	enemy.hurtbox.set_deferred("monitoring", false)
	enemy.hurtbox.set_deferred("monitorable", false)


func _apply_gravity(delta: float) -> void:
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * delta


func _on_animation_finished() -> void:
	enemy.queue_free()
