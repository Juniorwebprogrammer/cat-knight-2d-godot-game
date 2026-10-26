@tool
class_name Treasure
extends Area2D

signal collected(id: StringName)

@export var treasure_id: StringName = &"sword"
@export var texture: Texture2D:
	set(value):
		texture = value
		_apply_texture()
@export_range(8.0, 48.0, 1.0) var max_size: float = 40.0:
	set(value):
		max_size = value
		_apply_texture()
@export var sway_angle_degrees: float = 12.0
@export var sway_duration: float = 0.8

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var _is_collected: bool = false
var _sway_tween: Tween


func _ready() -> void:
	_apply_texture()
	if Engine.is_editor_hint():
		return
	body_entered.connect(_on_body_entered)
	_start_sway()


func _apply_texture() -> void:
	if not sprite or not collision_shape or not texture:
		return
	var factor := max_size / maxf(texture.get_width(), texture.get_height())
	sprite.texture = texture
	sprite.scale = Vector2(factor, factor)
	sprite.offset = Vector2(0.0, -texture.get_height() / 2.0)
	_fit_collision(texture.get_size() * factor)


func _fit_collision(size: Vector2) -> void:
	var rect := RectangleShape2D.new()
	rect.size = size
	collision_shape.shape = rect
	collision_shape.position = Vector2(0.0, -size.y / 2.0)


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
	Treasures.unlock(treasure_id)
	collected.emit(treasure_id)
	queue_free()


func _stop_sway() -> void:
	if _sway_tween:
		_sway_tween.kill()


func _disable_collision() -> void:
	collision_shape.set_deferred("disabled", true)
