# antagonista.gd
class_name Vilao
extends CharacterBody3D

@export var velocidade: float = 5.0
@export var vida_max: int = 100
var vida: int = vida_max

# Referência ao jogador (ajuste para o seu jogo)
@onready var jogador: Node3D = get_tree().get_first_node_in_group("jogador")  # Ou use um path

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	# A máquina gerencia a lógica nos estados
	# Aqui só aplicamos o movimento final
	move_and_slide()
	#
	## Exemplo: Checar morte global (fora dos estados)
	#if vida <= 0 and $MaquinaDeEstados.estado_atual.name != "Morrendo":
		#$MaquinaDeEstados.ao_transitar_estado_filho($MaquinaDeEstados.estado_atual, "Morrendo")
