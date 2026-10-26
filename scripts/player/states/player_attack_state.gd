class_name PlayerAttackState
extends State

var _attack: PlayerAttack


func enter() -> void:
	player.velocity.x = 0.0
	_attack = player.attack_component.begin_requested()
	_attack.finished.connect(_on_attack_finished)


func exit() -> void:
	_disconnect_attack()
	player.attack_component.cancel_current()


func update(delta: float) -> void:
	_apply_gravity(delta)
	player.move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta


func _disconnect_attack() -> void:
	if _attack and _attack.finished.is_connected(_on_attack_finished):
		_attack.finished.disconnect(_on_attack_finished)


func _on_attack_finished() -> void:
	player.state_machine.change_state("Idle")
