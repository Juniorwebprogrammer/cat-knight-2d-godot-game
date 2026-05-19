# idle_state.gd
class_name IdleState
extends State

func enter() -> void:
	player.animated_sprite.play("idle")

func update(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta

	player.velocity.x = 0
	player.move_and_slide()

	# Comprobar teclas ya pulsadas (no solo eventos nuevos)
	if Input.is_action_pressed("MoveRight") or Input.is_action_pressed("MoveLeft"):
		player.state_machine.change_state("Run")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("MoveRight") or event.is_action_pressed("MoveLeft"):
		player.state_machine.change_state("Run")
	if event.is_action_pressed("Jump") and player.is_on_floor():
		player.state_machine.change_state("Jump")
	if event.is_action_pressed("Dodge") and player.is_on_floor():
		player.state_machine.change_state("Dodge")
	if event.is_action_pressed("Attack1") and player.is_on_floor():
		player.state_machine.change_state("Attack1")
