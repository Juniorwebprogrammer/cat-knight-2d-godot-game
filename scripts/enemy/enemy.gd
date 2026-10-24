class_name Enemy
extends CharacterBody2D

@export var patrol_speed: int = 80
@export var gravity: int = 1500
@export var attack_cooldown: float = 1.0
@export var knockback_force: Vector2 = Vector2(200, -150)

@onready var health: HealthEnemyComponent = $HealthEnemyComponent
@onready var hurtbox: Area2D = $Hurtbox
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_range: Area2D = $AttackRange
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var state_machine: EnemyStateMachine = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var home_x: float = 0.0

var _attack_ready_at: float = 0.0

func _ready() -> void:
	home_x = global_position.x
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	health.damaged.connect(_on_damaged)
	health.died.connect(_on_died)
	state_machine.init(self, "Patrol")

func _physics_process(delta: float) -> void:
	state_machine.update(delta)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.has_meta("damage"):
		health.take_damage(area.get_meta("damage"), area.global_position)

func _on_damaged(_amount: int, hit_direction: Vector2) -> void:
	_apply_knockback(hit_direction)
	state_machine.change_state("Hurt")

func _on_died() -> void:
	state_machine.change_state("Dead")

func _apply_knockback(hit_direction: Vector2) -> void:
	velocity = Vector2(knockback_force.x * signf(hit_direction.x), knockback_force.y)

func _is_player_in_area(area: Area2D) -> bool:
	for body in area.get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false

func is_player_detected() -> bool:
	return _is_player_in_area(detection_area)
	
func is_player_in_attack_range() -> bool:
	return _is_player_in_area(attack_range)

func can_attack() -> bool:
	return Time.get_ticks_msec() / 1000.0 >= _attack_ready_at

func start_attack_cooldown() -> void:
	_attack_ready_at = Time.get_ticks_msec() / 1000.0 + attack_cooldown

func face_direction(direction_x: float) -> void:
	if direction_x == 0.0:
		return
	var facing_left := direction_x < 0.0
	var scale_x := -1.0 if facing_left else 1.0
	animated_sprite.flip_h = facing_left
	detection_area.scale.x = scale_x
	attack_range.scale.x = scale_x
	attack_hitbox.scale.x = scale_x

func get_facing_direction() -> float:
	return -1.0 if animated_sprite.flip_h else 1.0
