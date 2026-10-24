class_name AttackState
extends EnemyState

@export var hit_start_frame: int = 2
@export var hit_end_frame: int = 4


func enter() -> void:
	_stop_moving()
	_face_player()
	_play_attack_animation()
	_connect_signals()


func exit() -> void:
	_set_hitbox_active(false)
	_disconnect_signals()
	enemy.start_attack_cooldown()


func update(delta: float) -> void:
	_apply_gravity(delta)
	enemy.move_and_slide()


func _stop_moving() -> void:
	enemy.velocity.x = 0.0


func _face_player() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	enemy.face_direction(signf(player.global_position.x - enemy.global_position.x))


func _play_attack_animation() -> void:
	enemy.animated_sprite.play("Attack")


func _connect_signals() -> void:
	enemy.animated_sprite.frame_changed.connect(_on_frame_changed)
	enemy.animated_sprite.animation_finished.connect(_on_animation_finished)


func _disconnect_signals() -> void:
	enemy.animated_sprite.frame_changed.disconnect(_on_frame_changed)
	enemy.animated_sprite.animation_finished.disconnect(_on_animation_finished)


func _apply_gravity(delta: float) -> void:
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * delta


func _set_hitbox_active(active: bool) -> void:
	enemy.attack_hitbox.set_deferred("monitorable", active)


func _on_frame_changed() -> void:
	var frame := enemy.animated_sprite.frame
	_set_hitbox_active(frame >= hit_start_frame and frame <= hit_end_frame)


func _on_animation_finished() -> void:
	if enemy.is_player_detected():
		state_machine.change_state("Pursue")
	else:
		state_machine.change_state("Patrol")
