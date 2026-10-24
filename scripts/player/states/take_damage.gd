# take_damage.gd
extends State

@export var stun_duration: float = 0.25
@export var knockback_speed: float = 250.0
@export var invulnerability_time: float = 0.8

var _time_left: float = 0.0


func enter() -> void:
	_time_left = stun_duration
	player.velocity = player.health.last_hit_direction * knockback_speed
	player.health.start_invulnerability(invulnerability_time)
	player.animated_sprite.play("take_damage")

func update(delta: float) -> void:
	_apply_friction(delta)
	player.move_and_slide()
	_tick_stun(delta)


# --- Funciones privadas auxiliares ---

func _apply_friction(delta: float) -> void:
	var friction := knockback_speed / stun_duration
	player.velocity = player.velocity.move_toward(Vector2.ZERO, friction * delta)


func _tick_stun(delta: float) -> void:
	_time_left -= delta
	if _time_left <= 0.0:
		_finish_stun()


func _finish_stun() -> void:
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "Jump", "Dodge")
	var next_state := "Move" if input_dir != Vector2.ZERO else "Idle"
	player.state_machine.change_state(next_state)
