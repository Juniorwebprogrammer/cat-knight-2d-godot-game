class_name DodgeState
extends State

var dodge_direction: float = 1.0

func enter() -> void:
	print(">>> ENTER DODGE")
	player.animated_sprite.play("dodge")
	dodge_direction = -1.0 if player.animated_sprite.flip_h else 1.0

func exit() -> void:
	print(">>> EXIT DODGE")

func update(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta

	player.velocity.x = dodge_direction * player.dodge_speed
	player.move_and_slide()

	if not player.animated_sprite.is_playing():
		# Ir a Run directamente si ya hay tecla pulsada
		if Input.is_action_pressed("MoveRight") or Input.is_action_pressed("MoveLeft"):
			player.state_machine.change_state("Run")
		else:
			player.state_machine.change_state("Idle")
