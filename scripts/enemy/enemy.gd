extends CharacterBody2D

@export var max_health: int = 50
@export var patrol_speed: int = 80
@export var gravity: int = 1500
@export var knockback_force: Vector2 = Vector2(200, -150)

var current_health: int

@onready var color_rect: ColorRect = $ColorRect
@onready var hurtbox: Area2D = $Hurtbox
@onready var left_point: Marker2D = $PatrolPoints/Left
@onready var right_point: Marker2D = $PatrolPoints/Right
@onready var state_machine: EnemyStateMachine = $StateMachine

func _ready() -> void:
	current_health = max_health
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	state_machine.init(self, "Patrol")

func _physics_process(delta: float) -> void:
	state_machine.update(delta)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	print(">>> HURTBOX tocada por: ", area.name)
	print(">>> Tiene meta damage: ", area.has_meta("damage"))
	if area.has_meta("damage"):
		var damage = area.get_meta("damage")
		print(">>> Daño recibido: ", damage)
		take_damage(damage, area)

func take_damage(amount: int, source: Area2D) -> void:
	# No recibir daño si ya está muerto
	if state_machine.current_state.name == "Dead":
		return

	current_health -= amount
	print("Enemigo recibe ", amount, " daño. Vida: ", current_health, "/", max_health)

	# Calcular dirección del knockback según de dónde viene el golpe
	var knockback_dir = 1.0 if global_position.x > source.global_position.x else -1.0
	velocity = Vector2(knockback_force.x * knockback_dir, knockback_force.y)

	if current_health <= 0:
		state_machine.change_state("Dead")
	else:
		state_machine.change_state("Hurt")
