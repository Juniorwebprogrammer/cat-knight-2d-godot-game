class_name PursueState
extends EnemyState

@export var chase_speed: float = 140.0
@export var chase_duration: float = 2.0

var _time_left: float = 0.0


func enter() -> void:
	refresh()


func update(delta: float) -> void:
	_refresh_if_player_detected()
	_apply_gravity(delta)
	_move_towards_player()
	_tick_timer(delta)
	_attack_if_player_in_range()
	enemy.move_and_slide()

func refresh() -> void:
	_time_left = chase_duration

func _refresh_if_player_detected() -> void:
	if enemy.is_player_detected():
		refresh()

func _apply_gravity(delta: float) -> void:
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * delta

func _move_towards_player() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var direction_x := signf(player.global_position.x - enemy.global_position.x)
	enemy.velocity.x = direction_x * chase_speed
	enemy.face_direction(direction_x)
	enemy.animated_sprite.play("Walk")

func _tick_timer(delta: float) -> void:
	_time_left -= delta
	if _time_left <= 0.0:
		state_machine.change_state("Patrol")

func _attack_if_player_in_range() -> void:
	print("can_attack: ", enemy.can_attack(), " | in_range: ", enemy.is_player_in_attack_range())
	if enemy.can_attack() and enemy.is_player_in_attack_range():
		state_machine.change_state("Attack")
