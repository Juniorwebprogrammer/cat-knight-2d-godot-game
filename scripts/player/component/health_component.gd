class_name HealthComponent
extends Node

@export var max_health: int = 100

var health: int
var current: int
var maximum: int

var last_hit_direction: Vector2 = Vector2.ZERO

var _invulnerable_time_left: float = 0.0

signal health_changed(current, maximum)
signal damaged(amount)
signal died

func _ready() -> void:
	health = max_health

func _physics_process(delta: float) -> void:
	_tick_invulnerability(delta)

func take_damage(_amount: int, _source_position: Vector2) -> void:
	if not _can_take_damage():
		return
	_apply_damage(_amount)
	_store_hit_direction(_source_position)
	_emit_result(_amount)

func start_invulnerability(_duration: float) -> void:
	_invulnerable_time_left = _duration

func is_dead() -> bool:
	return health <= 0

func _can_take_damage() -> bool:
	return not is_dead() and _invulnerable_time_left <= 0.0

func _apply_damage(amount) -> void:
	health = maxi(health - amount, 0)
	health_changed.emit(health, max_health)

func _store_hit_direction(_source_position: Vector2) -> void:
	var owner_node := get_parent() as Node2D
	last_hit_direction = (owner_node.global_position - _source_position).normalized()

func _emit_result(_amount: int) -> void:
	if is_dead():
		died.emit()
	else:
		damaged.emit(_amount)

func _tick_invulnerability(delta: float) -> void:
	_invulnerable_time_left = maxf(_invulnerable_time_left - delta, 0.0)
