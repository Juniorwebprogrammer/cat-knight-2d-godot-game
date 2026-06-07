class_name EnemyStateMachine
extends Node

var current_state: EnemyState
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is EnemyState:
			states[child.name] = child

func init(enemy: CharacterBody2D, initial_state: String) -> void:
	for state in states.values():
		state.enemy = enemy
	change_state(initial_state)

func change_state(new_state: String) -> void:
	print(">>> ENEMY CHANGE STATE: ", 
		current_state.name if current_state else "none", 
		" -> ", new_state)
	if current_state:
		current_state.exit()
	current_state = states[new_state]
	current_state.enter()

func update(delta: float) -> void:
	current_state.update(delta)
