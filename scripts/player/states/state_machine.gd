# state_machine.gd
class_name StateMachine
extends Node

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	# Registra todos los estados hijos automáticamente
	for child in get_children():
		if child is State:
			states[child.name] = child

func init(player: CharacterBody2D, initial_state: String) -> void:
	for state in states.values():
		state.player = player
	change_state(initial_state)

func change_state(new_state: String) -> void:
	if current_state:
		current_state.exit()
	current_state = states[new_state]
	current_state.enter()

func update(delta: float) -> void:
	current_state.update(delta)

func handle_input(event: InputEvent) -> void:
	current_state.handle_input(event)
