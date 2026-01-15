extends CharacterBody3D

# Componentes
@onready var arvore_animacao: AnimationTree = $Anim_tree
@onready var estado_animacao: AnimationNodeStateMachinePlayback = arvore_animacao.get("parameters/playback")
@onready var malha: Node3D = $"Skinned Mesh 0"

# Atributos
@export var vida_maxima: int = 100
var vida: int = vida_maxima

# Constantes
const VELOCIDADE_ANDAR: float = 1.0
const VELOCIDADE_CORRER: float = 7.0
const FORCA_PULO: float = 4.5
const LERP_ROTACAO: float = 0.1

func _ready() -> void:
	arvore_animacao.active = true

func _physics_process(delta: float) -> void:
	aplicar_gravidade(delta)
	verificar_pulo()
	
	var entrada: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direcao: Vector3 = (transform.basis * Vector3(entrada.x, 0, entrada.y)).normalized()
	var correndo: bool = Input.is_action_pressed("correr")
	var velocidade: float = VELOCIDADE_CORRER if correndo else VELOCIDADE_ANDAR
	
	mover_personagem(direcao, velocidade)
	atualizar_animacao(direcao, correndo)
	
	move_and_slide()

func aplicar_gravidade(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func verificar_pulo() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = FORCA_PULO

func mover_personagem(direcao: Vector3, velocidade: float) -> void:
	if direcao:
		velocity.x = direcao.x * velocidade
		velocity.z = direcao.z * velocidade
		
		var alvo_yaw = atan2(direcao.x, direcao.z)
		malha.rotation.y = lerp_angle(malha.rotation.y, alvo_yaw, LERP_ROTACAO)
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade)
		velocity.z = move_toward(velocity.z, 0, velocidade)

func atualizar_animacao(direcao: Vector3, correndo: bool) -> void:
	var em_movimento: bool = direcao != Vector3.ZERO
	
	arvore_animacao.set("parameters/pode_andar", em_movimento and not correndo)
	arvore_animacao.set("parameters/pode_correr", em_movimento and correndo)
	arvore_animacao.set("parameters/voltar_a_andar", em_movimento and not correndo)
	arvore_animacao.set("parameters/voltar_a_parar", not em_movimento)

	if em_movimento:
		if correndo:
			estado_animacao.travel("Run Anime")
		else:
			estado_animacao.travel("Walk_Formal")
	else:
		estado_animacao.travel("Idle")
