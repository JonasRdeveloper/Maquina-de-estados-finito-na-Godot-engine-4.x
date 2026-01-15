## res://src/roteiros/antagonista/antagonista.gd
class_name Vilao
extends CharacterBody3D

@export var gravidade: float = 50.0
@export var velocidade: float = 4.0
@export var velocidade_correr: float = 10.0
@export var vida_max: int = 500
var vida: int = vida_max

const LERP_VALUE : float = 0.1
const ANIMATION_BLEND : float = 7.0

# Suavização/controle de movimento
const ACCELERATION : float = 6.0        # quanto mais alto, mais rápido alcança target_velocity
const PERSONAL_SPACE : float = 1.5      # distância mínima para aplicar repulsão
const RETREAT_SPEED : float = 2.0       # velocidade de recuo quando jogador está muito perto
const DEADZONE : float = 0.05           # zera micro-movimentos

## Referências (ajuste caminhos no Inspector se necessário)
@onready var jogador := get_tree().get_first_node_in_group("jogador") as CharacterBody3D
@onready var anim_tree := $Arvore_de_animacoes as AnimationTree
@export var player_mesh : Node3D  # arraste seu nó de mesh no Inspector
@onready var maquina_estados := $Maquina_de_estados as Node  # ajuste se o nó estiver em outro caminho

# Movimento
var desired_velocity: Vector3 = Vector3.ZERO
var target_velocity: Vector3 = Vector3.ZERO   # alvo final (após lógica de estados + repulsão)
# 'velocity' vem de CharacterBody3D

func _ready() -> void:
	if not anim_tree:
		push_error("Arvore_de_animacoes não encontrado!")
	else:
		anim_tree.active = true

func _physics_process(delta: float) -> void:
	# 1) Gravidade (mantém componente Y)
	if not is_on_floor():
		velocity.y -= gravidade * delta
	else:
		velocity.y = 0.0

	# 2) Permite que a máquina de estados atualize desired_velocity (no physics tick)
	if maquina_estados and maquina_estados.has_method("atualizar_fisica"):
		maquina_estados.atualizar_fisica(delta)

	# 3) Calcula target_velocity a partir do desired_velocity dos estados
	target_velocity = desired_velocity

	# 4) Se o jogador estiver muito próximo, aplica repulsão suave (afasta o vilão)
	if jogador:
		var dist = global_position.distance_to(jogador.global_position)
		if dist < PERSONAL_SPACE:
			# vetor de afastamento no plano XZ
			var away = (global_position - jogador.global_position)
			away.y = 0
			if away.length_squared() == 0.0:
				# jogador exatamente no mesmo ponto: escolhe uma direção arbitrária
				away = Vector3(1, 0, 0)
			away = away.normalized()
			# mistura repulsão com target_velocity atual (prioriza afastamento)
			var retreat = away * RETREAT_SPEED
			# blend entre o target atual e o retreat para não trocar bruscamente
			target_velocity = target_velocity.lerp(retreat, 0.9)
	
	# 5) Suaviza a mudança de desired_velocity em direção ao target_velocity
	#    Isso faz o vilão "acelerar" e "desacelerar" gradualmente
	desired_velocity = desired_velocity.lerp(target_velocity, clamp(delta * ACCELERATION, 0.0, 1.0))

	# 6) Aplica desired_velocity apenas nas componentes horizontais (X,Z)
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z

	# 7) Deadzone para evitar micro-oscilações no plano horizontal
	var vel_h = Vector3(velocity.x, 0.0, velocity.z)
	if vel_h.length() < DEADZONE:
		velocity.x = 0.0
		velocity.z = 0.0
		vel_h = Vector3.ZERO

	# 8) Move usando o sistema de física
	move_and_slide()

	# 9) Usa a velocidade efetiva após move_and_slide para rotação e animação
	_atualizar_rotacao_e_animacao(delta, vel_h)

func _atualizar_rotacao_e_animacao(delta: float, vel_h: Vector3) -> void:
	# Rotação suave ignorando Y (usa velocidade efetiva)
	if vel_h.length_squared() > 0.0001 and player_mesh:
		var target_yaw = atan2(vel_h.x, vel_h.z)
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, target_yaw, LERP_VALUE)

	# Blend de animações baseado na velocidade horizontal
	if is_on_floor() and anim_tree:
		var velocidade_atual = vel_h.length()
		var blend_target: float
		if velocidade_atual == 0.0:
			blend_target = -1.0
		elif velocidade_atual <= velocidade:
			blend_target = 0.0
		else:
			blend_target = 1.0

		var path = "parameters/Movimento_terrestre/blend_amount"
		var current = anim_tree.get(path)
		anim_tree.set(path, lerp(current, blend_target, delta * ANIMATION_BLEND))
