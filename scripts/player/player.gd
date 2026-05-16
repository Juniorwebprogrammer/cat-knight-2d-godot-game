extends CharacterBody2D

@export var speed: int = 400
@export var jump_force: int = -600
@export var gravity: int = 1500
@export var dodge_speed: int = 700
@export var dodge_duration: float = 0.4

var screen_size: Vector2
var is_dodging: bool = false
var dodge_timer: float = 0.0
var dodge_direction: float = 1.0

func _ready() -> void:
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	$AnimatedSprite2D.scale = Vector2(3, 3)

func _physics_process(delta: float) -> void:
	# --- GRAVEDAD ---
	if not is_on_floor():
		velocity.y += gravity * delta

	# --- SALTO ---
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_force

	# --- DODGE ---
	if Input.is_action_just_pressed("Dodge") and is_on_floor() and not is_dodging:
		is_dodging = true
		dodge_timer = dodge_duration
		dodge_direction = -1.0 if $AnimatedSprite2D.flip_h else 1.0
		$AnimatedSprite2D.play("dodge")

	if is_dodging:
		dodge_timer -= delta
		if dodge_timer <= 0:
			is_dodging = false

	# --- MOVIMIENTO HORIZONTAL ---
	if is_dodging:
		velocity.x = dodge_direction * dodge_speed
	else:
		var direction_x: float = 0
		if Input.is_action_pressed("MoveRight"):
			direction_x += 1
		if Input.is_action_pressed("MoveLeft"):
			direction_x -= 1
		velocity.x = direction_x * speed

	# --- ANIMACIONES ---
	if is_dodging:
		pass
	elif not is_on_floor():
		if $AnimatedSprite2D.animation != "jump":
			$AnimatedSprite2D.play("jump")
	elif velocity.x != 0:
		if $AnimatedSprite2D.animation != "run":
			$AnimatedSprite2D.play("run")
	else:
		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")

	# --- VOLTEAR SPRITE ---
	if not is_dodging and velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

	# --- APLICAR MOVIMIENTO ---
	move_and_slide()
