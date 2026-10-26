class_name PlayerAttack
extends Node

signal finished

@export var required_treasure: StringName = &""
@export var animation_name: StringName = &"attack1"
@export var damage: int = 10
@export var hit_start_frame: int = 2
@export var hit_end_frame: int = 4
@export var cooldown: float = 0.4
@export var only_on_floor: bool = true

var player: Player

var _ready_at: float = 0.0
var _is_active: bool = false


func setup(owner_player: Player) -> void:
	player = owner_player
	_on_setup()

func can_start() -> bool:
	return _is_unlocked() and _is_cooldown_over() and _is_position_valid()

func start() -> void:
	_is_active = true
	_connect_signals()
	player.animated_sprite.play(animation_name)
	_on_start()

func cancel() -> void:
	_end()

# Los ataques concretos sobrescriben estos tres métodos
func _on_setup() -> void:
	pass

func _on_start() -> void:
	pass

func _set_hit_active(_active: bool) -> void:
	pass

func _is_unlocked() -> bool:
	return required_treasure == &"" or Treasures.is_unlocked(required_treasure)

func _is_cooldown_over() -> bool:
	return Time.get_ticks_msec() / 1000.0 >= _ready_at

func _is_position_valid() -> bool:
	return player.is_on_floor() or not only_on_floor

func _connect_signals() -> void:
	player.animated_sprite.frame_changed.connect(_on_frame_changed)
	player.animated_sprite.animation_finished.connect(_on_animation_finished)

func _disconnect_signals() -> void:
	if player.animated_sprite.frame_changed.is_connected(_on_frame_changed):
		player.animated_sprite.frame_changed.disconnect(_on_frame_changed)
	if player.animated_sprite.animation_finished.is_connected(_on_animation_finished):
		player.animated_sprite.animation_finished.disconnect(_on_animation_finished)

func _on_frame_changed() -> void:
	var frame := player.animated_sprite.frame
	_set_hit_active(frame >= hit_start_frame and frame <= hit_end_frame)

func _on_animation_finished() -> void:
	_end()
	finished.emit()

func _end() -> void:
	if not _is_active:
		return
	_is_active = false
	_set_hit_active(false)
	_disconnect_signals()
	_ready_at = Time.get_ticks_msec() / 1000.0 + cooldown
