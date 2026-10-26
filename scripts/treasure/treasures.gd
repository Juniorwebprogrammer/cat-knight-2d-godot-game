extends Node

signal treasure_unlocked(id: StringName)

var _unlocked: Dictionary = {}

func unlock(id: StringName) -> void:
	if is_unlocked(id):
		return
	_unlocked[id] = true
	treasure_unlocked.emit(id)

func is_unlocked(id: StringName) -> bool:
	return _unlocked.has(id)
