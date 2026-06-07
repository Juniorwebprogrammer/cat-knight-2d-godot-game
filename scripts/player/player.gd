# player.gd
extends CharacterBody2D

@export var speed: int = 400
@export var jump_force: int = -600
@export var gravity: int = 1500
@export var dodge_speed: int = 700
@export var attack1_damage: int = 10
@export var attack1_air_damage: int = 20
@export var slam_force: int = 200

@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	$AnimatedSprite2D.scale = Vector2(3, 3)
	state_machine.init(self, "Idle")
	# Logs de verificación
	print(">>> AttackHitbox layer: ", attack_hitbox.collision_layer)
	print(">>> AttackHitbox mask: ", attack_hitbox.collision_mask)

func _physics_process(delta: float) -> void:
	state_machine.update(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)
