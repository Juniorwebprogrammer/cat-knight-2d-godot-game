# death.gd
extends State


func enter() -> void:
	player.velocity = Vector2.ZERO
	_disable_collision()
	player.animated_sprite.play("death")


func update(_delta: float) -> void:
	pass  # Sin salida: el jugador no vuelve a ningún estado


func _disable_collision() -> void:
	player.get_node("CollisionShape2D").set_deferred("disabled", true)
