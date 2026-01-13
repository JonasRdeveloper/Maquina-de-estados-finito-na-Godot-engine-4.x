extends CharacterBody3D

@export var vida_max: int = 100  # Export pra ajustar no Inspector
var vida: int = vida_max  # Inicializa com max

const SPEED: float = 5.0
const RUN_SPEED: float = 50.0
const JUMP_VELOCITY: float = 4.5


func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Direção de input
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Velocidade atual (correndo ou andando)
	var current_speed: float = RUN_SPEED if Input.is_action_pressed("correr") else SPEED
	
	# Movimento
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		# Desaceleração suave usando a velocidade atual
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()
