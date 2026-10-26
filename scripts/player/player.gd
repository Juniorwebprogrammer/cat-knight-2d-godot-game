class_name Player
extends CharacterBody2D

@export var speed: int = 400
@export var jump_force: int = -600
@export var gravity: int = 1500
@export var dodge_speed: int = 700
@export var slam_force: int = 200
@export var live_count: int = 100

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var health: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent


func _ready() -> void:
	$AnimatedSprite2D.scale = Vector2(3, 3)
	attack_component.init(self)
	state_machine.init(self, "Idle")
	health.damaged.connect(_on_damaged)
	health.died.connect(_on_died)


func _physics_process(delta: float) -> void:
	state_machine.update(delta)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)


func get_facing_direction() -> float:
	return -1.0 if animated_sprite.flip_h else 1.0


func _on_damaged(_amount: int) -> void:
	state_machine.change_state("TakeDamage")


func _on_died() -> void:
	state_machine.change_state("Death")
