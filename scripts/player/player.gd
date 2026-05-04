extends Area2D

# Velocidad a la que puede moverse el jugador
@export var speed = 400
# Variable para guardar el tamaño de la ventana
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Obtener el tamaño de la ventana
	screen_size = get_viewport_rect().size
	
	# OPCIONAL: Centrar al personaje al inicio
	position = screen_size / 2
	
	# Escalado: Si se ve muy pequeño, lo agrandamos 3 veces (nítido)
	$AnimatedSprite2D.scale = Vector2(3, 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # El vector de movimiento del player
	
	# Capturar entradas de usuario
	if Input.is_action_pressed("MoveRight"):
		velocity.x += 1
	if Input.is_action_pressed("MoveLeft"):
		velocity.x -= 1
	if Input.is_action_pressed("MoveDown"):
		velocity.y += 1
	if Input.is_action_pressed("MoveUp"):
		velocity.y -= 1

	# Gestión de movimiento y animaciones
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
		# Cambiar a animación de correr si no está ya puesta
		if $AnimatedSprite2D.animation != "run":
			$AnimatedSprite2D.play("run")
	else:
		# Cambiar a animación de espera si no está ya puesta
		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")

	# Aplicar el movimiento real a la posición
	position += velocity * delta
	
	# Evitar que el usuario salga de la pantalla
	position = position.clamp(Vector2.ZERO, screen_size)

	# Voltear el personaje horizontalmente según la dirección
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
