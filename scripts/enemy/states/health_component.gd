class_name HealthEnemyComponent
extends Node

signal health_changed(current: int, maximum: int)
signal damaged(amount: int, hit_direction: Vector2)
signal died

@export var max_health: int = 100

var current_health: int

var last_hit_direction: Vector2 = Vector2.ZERO
var _invulnerable_time_left: float = 0.0

func _ready() -> void:
	current_health = max_health

func _physics_process(delta: float) -> void:
	_tick_invulnerability(delta)

func take_damage(amount: int, source_position: Vector2) -> void:
	if not _can_take_damage():
		return
	_apply_damage(amount)
	_store_hit_direction(source_position)
	_emit_result(amount)


func start_invulnerability(duration: float) -> void:
	_invulnerable_time_left = duration

func is_dead() -> bool:
	return current_health <= 0

func _can_take_damage() -> bool:
	return not is_dead() and _invulnerable_time_left <= 0.0

func _apply_damage(amount: int) -> void:
	current_health = maxi(current_health - amount, 0)
	health_changed.emit(current_health, max_health)

func _store_hit_direction(source_position: Vector2) -> void:
	var owner_node := get_parent() as Node2D
	last_hit_direction = (owner_node.global_position - source_position).normalized()

func _emit_result(amount: int) -> void:
	if is_dead():
		died.emit()
	else:
		damaged.emit(amount, last_hit_direction)

func _tick_invulnerability(delta: float) -> void:
	_invulnerable_time_left = maxf(_invulnerable_time_left - delta, 0.0)
