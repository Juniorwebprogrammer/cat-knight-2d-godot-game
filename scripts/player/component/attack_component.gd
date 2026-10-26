class_name AttackComponent
extends Node

@export var selected_attack: StringName = &"SwordSlash"

var current_attack: PlayerAttack

var _attacks: Dictionary = {}
var _requested: StringName = &""

func init(player: Player) -> void:
	for child in get_children():
		if child is PlayerAttack:
			child.setup(player)
			_attacks[child.name] = child

func request_selected() -> bool:
	return request(selected_attack)

func request(id: StringName) -> bool:
	if not can_attack(id):
		return false
	_requested = id
	return true

func can_attack(id: StringName) -> bool:
	return _attacks.has(id) and (_attacks[id] as PlayerAttack).can_start()

func begin_requested() -> PlayerAttack:
	current_attack = _attacks[_requested] as PlayerAttack
	_requested = &""
	current_attack.start()
	return current_attack

func cancel_current() -> void:
	if current_attack:
		current_attack.cancel()
