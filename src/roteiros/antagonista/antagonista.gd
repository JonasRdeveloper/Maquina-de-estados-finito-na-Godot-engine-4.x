# antagonista.gd
class_name Vilao
extends CharacterBody3D

@export var gravidade: float = 50.0
@export var velocidade: float = 2.0  # Andando
@export var velocidade_correr: float = 10.0  # Correndo (inspirado no run_speed)
@export var vida_max: int = 500
var vida: int = vida_max

const LERP_VALUE : float = 0.1  # Suavidade rotação (do original)
const ANIMATION_BLEND : float = 7.0  # Suavidade blend animações

# Referências
@onready var jogador := get_tree().get_first_node_in_group("jogador") as CharacterBody3D
@onready var area_ataque := $AreaAtaque_chefe1 as Area3D
@onready var anim_tree := $Arvore_de_animacoes as AnimationTree
@export var player_mesh : Node3D  # Ajuste pro seu modelo (do screenshot)

func _ready() -> void:
	if not area_ataque:
		push_error("AreaAtaque_chefe1 não encontrado!")
	else:
		area_ataque.monitoring = false
		area_ataque.body_entered.connect(_on_area_ataque_body_entered)
	
	if not anim_tree:
		push_error("Arvore_de_animacoes não encontrado!")
	else:
		anim_tree.active = true  # Ativa o tree

func _on_area_ataque_body_entered(body: Node3D) -> void:
	if body.is_in_group("jogador") and body.has_method("receber_dano"):
		body.receber_dano(20)
	print("Ataque acertou!")

func _physics_process(delta: float) -> void:
	# Gravidade sempre aplicada
	if not is_on_floor():
		velocity.y -= gravidade * delta
	else:
		velocity.y = 0.0  # Zera quando está no chão
	
	# Rotação suave pro mesh
	if velocity.length_squared() > 0.0:
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(velocity.x, velocity.z), LERP_VALUE)
	
	# Aplica movimento
	move_and_slide()
	
	# Blend de animações
	animate(delta)

	
func animate(delta: float) -> void:
	if is_on_floor():
		var velocidade_atual = velocity.length()
		var blend_target: float
		
		if velocidade_atual == 0.0:
			blend_target = -1.0  # Ocioso
		elif velocidade_atual <= velocidade:
			blend_target = 0.0  # Andando
		else:
			blend_target = 1.0  # Correndo
		

		anim_tree.set("parameters/Movimento_terrestre/blend_amount", lerp(anim_tree.get("parameters/Movimento_terrestre/blend_amount"), blend_target, delta * ANIMATION_BLEND))
