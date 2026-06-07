class_name Attack1State
extends State

@export var hitbox_active_frame: int = 1
@export var hitbox_inactive_frame: int = 3
@export var air_attack_up_force: int = 150

var was_in_air: bool = false
var has_slammed: bool = false  # Ya inició la caída fuerte

func enter() -> void:
	was_in_air = not player.is_on_floor()
	has_slammed = false

	if was_in_air:
		# Mostrar frame 0 (levanta espada) y dar impulso arriba
		player.animated_sprite.play("attack1")
		player.animated_sprite.pause()
		player.animated_sprite.frame = 0
		player.velocity.y = -air_attack_up_force
		player.velocity.x = 0
	else:
		player.animated_sprite.play("attack1")
		player.velocity.x = 0

	player.animated_sprite.frame_changed.connect(_on_frame_changed)
	player.animated_sprite.animation_finished.connect(
		_on_animation_finished, CONNECT_ONE_SHOT
	)

func exit() -> void:
	has_slammed = false
	_deactivate_hitbox()
	if player.animated_sprite.frame_changed.is_connected(_on_frame_changed):
		player.animated_sprite.frame_changed.disconnect(_on_frame_changed)

func update(delta: float) -> void:
	if was_in_air:
		player.velocity.y += player.gravity * delta
		player.velocity.x = 0

		if not has_slammed:
			# Mientras sube o está en el punto más alto: frame 0
			player.animated_sprite.frame = 0
			# Cuando empieza a caer: soltar animación
			if player.velocity.y > 50:
				has_slammed = true
				player.animated_sprite.play()  # Continúa desde frame 0
		else:
			if player.is_on_floor():
				_finish_attack()
	else:
		if not player.is_on_floor():
			player.velocity.y += player.gravity * delta
		player.velocity.x = 0

	player.move_and_slide()

func handle_input(_event: InputEvent) -> void:
	pass

func _on_frame_changed() -> void:
	var frame = player.animated_sprite.frame
	if frame == hitbox_active_frame:
		_activate_hitbox()
	elif frame == hitbox_inactive_frame:
		_deactivate_hitbox()

func _activate_hitbox() -> void:
	var hitbox = player.get_node("AttackHitbox")
	# Voltear la hitbox según la dirección del sprite
	if player.animated_sprite.flip_h:
		hitbox.position.x = -60  # Izquierda
	else:
		hitbox.position.x = 60   # Derecha
	hitbox.monitoring = true
	hitbox.monitorable = true
	hitbox.set_meta("damage", _get_damage())

func _deactivate_hitbox() -> void:
	var hitbox = player.get_node("AttackHitbox")
	hitbox.monitoring = false
	hitbox.monitorable = false

func _get_damage() -> int:
	return player.attack1_air_damage if was_in_air else player.attack1_damage

func _on_animation_finished() -> void:
	if player.animated_sprite.animation == "attack1":
		_finish_attack()

func _finish_attack() -> void:
	if Input.is_action_pressed("MoveRight") or Input.is_action_pressed("MoveLeft"):
		player.state_machine.change_state("Run")
	else:
		player.state_machine.change_state("Idle")
