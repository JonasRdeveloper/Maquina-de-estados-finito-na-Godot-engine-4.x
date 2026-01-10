# antagonista.gd
class_name Vilao
extends CharacterBody3D

@export var velocidade: float = 5.0
@export var vida_max: int = 500
var vida: int = vida_max

# Referência ao jogador (ajuste para o seu jogo)
@onready var jogador := get_tree().get_first_node_in_group("jogador") as CharacterBody3D  # Ou use um path
@onready var area_ataque := get_node("AreaAtaque_chefe1") as Area3D
@onready var anim_player := get_node("Anim_chefe1") as AnimationPlayer

func _ready() -> void:
	if not area_ataque:
		push_error("AreaAtaque não encontrado!")
	area_ataque.monitoring = false  # Inicial off
	area_ataque.body_entered.connect(_on_area_ataque_body_entered)
	
func _on_area_ataque_body_entered(body: Node3D) -> void:
	if body.is_in_group("jogador"):
		body.vida -= 20  ## Dano automático!

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	## A máquina gerencia a lógica nos estados
	## Aqui só aplico o movimento final
	move_and_slide()
	#
	## Exemplo: Checar morte global (fora dos estados)
	#if vida <= 0 and $MaquinaDeEstados.estado_atual.name != "Morrendo":
		#$MaquinaDeEstados.ao_transitar_estado_filho($MaquinaDeEstados.estado_atual, "Morrendo")
