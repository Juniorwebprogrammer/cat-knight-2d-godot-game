class_name RunState
extends State

func enter() -> void:
	player.animated_sprite.play("run")

func update(delta: float) -> void:
	if not player.is_on_floor():
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

	# Transiciones automáticas
	if not player.is_on_floor():
		player.state_machine.change_state("Jump")
	elif direction_x == 0:
		player.state_machine.change_state("Idle")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump") and player.is_on_floor():
		player.state_machine.change_state("Jump")
	if event.is_action_pressed("Dodge") and player.is_on_floor():
		player.state_machine.change_state("Dodge")
