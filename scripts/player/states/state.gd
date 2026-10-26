class_name State
extends Node

var player: Player


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	pass


# Lo comparten los estados desde los que se puede atacar
func try_attack(event: InputEvent) -> bool:
	if not event.is_action_pressed("Attack1"):
		return false
	if not player.attack_component.request_selected():
		return false
	player.state_machine.change_state("Attack")
	return true
