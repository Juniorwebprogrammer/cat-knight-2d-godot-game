class_name Treasure
extends Area2D

signal collected(value: int)

@export var value: int = 10
@export var sway_angle_degrees: float = 12.0
@export var sway_duration: float = 0.8

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var _is_collected: bool = false
var _sway_tween: Tween


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_start_sway()


func _start_sway() -> void:
	var angle := deg_to_rad(sway_angle_degrees)
	sprite.rotation = -angle
	sprite.flip_h = false
	_sway_tween = _create_sway_tween(angle)


func _create_sway_tween(angle: float) -> Tween:
	var tween := create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "rotation", angle, sway_duration)
	tween.tween_callback(_set_flip.bind(true))
	tween.tween_property(sprite, "rotation", -angle, sway_duration)
	tween.tween_callback(_set_flip.bind(false))
	return tween


func _set_flip(flipped: bool) -> void:
	sprite.flip_h = flipped


func _on_body_entered(body: Node2D) -> void:
	if _is_collected:
		return
	if body.is_in_group("player"):
		_collect()


func _collect() -> void:
	_is_collected = true
	_stop_sway()
	_disable_collision()
	collected.emit(value)
	queue_free()


func _stop_sway() -> void:
	if _sway_tween:
		_sway_tween.kill()


func _disable_collision() -> void:
	collision_shape.set_deferred("disabled", true)
