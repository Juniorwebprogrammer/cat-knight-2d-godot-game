class_name EnemyStateMachine
extends Node

var current_state: EnemyState
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is EnemyState:
			states[child.name] = child

func init(enemy: Enemy, initial_state: String) -> void:
	for child in get_children():
		if child is EnemyState:
			child.enemy = enemy
			child.state_machine = self
	print(initial_state)
	change_state(initial_state)

func change_state(new_state: String) -> void:
	if current_state:
		current_state.exit()
	current_state = states[new_state]
	print(current_state)
	current_state.enter()

func update(delta: float) -> void:
	current_state.update(delta)
