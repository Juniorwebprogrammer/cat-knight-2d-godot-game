class_name JumpState
extends State

func enter() -> void:
	player.animated_sprite.play("jump")
	player.velocity.y = player.jump_force

func update(delta: float) -> void:
	player.velocity.y += player.gravity * delta

	var direction_x: float = 0
	if Input.is_action_pressed("MoveRight"):
		direction_x += 1
	if Input.is_action_pressed("MoveLeft"):
		direction_x -= 1

	player.velocity.x = direction_x * player.speed

	# Voltear sprite
	if direction_x != 0:
		player.animated_sprite.flip_h = direction_x < 0

	player.move_and_slide()

	# Al tocar el suelo volver a Idle o Run
	if player.is_on_floor():
		if direction_x != 0:
			player.state_machine.change_state("Run")
		else:
			player.state_machine.change_state("Idle")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack1"):
		player.state_machine.change_state("Attack1")
