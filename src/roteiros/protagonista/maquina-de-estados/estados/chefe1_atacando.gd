# chefe1_atacando.gd
class_name Estado_atacando_boss1
extends Interface_chefe1

const PROTAGONISTA_ATACANDO = preload("res://src/recursos/Protagonista_atacando.tres")

var chefe1: Vilao
var tempo_ataque: float = 0.0
@export var duracao_ataque: float = 2.0  # Tempo em ataque antes de voltar

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	tempo_ataque = 0.0
	var cor_da_malha := chefe1.get_node("MeshInstance") as MeshInstance3D
	cor_da_malha.mesh.surface_set_material(0, PROTAGONISTA_ATACANDO)
	print("Entrou em Atacando")
	# Ex: Tocar animação de ataque, causar dano ao jogador

func sair() -> void:
	print("Saiu de Atacando")

func atualizar(delta: float) -> void:
	tempo_ataque += delta
	if tempo_ataque > duracao_ataque:
		var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
		if dist > 10.0:  # Após ataque, se jogador fugiu, corre atrás
			transitado.emit(self, "Chefe1_correndo")
		else:
			transitado.emit(self, "Chefe1_atacando")

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	# Durante ataque, para o movimento
	chefe1.velocity = Vector3.ZERO
	# Ex: Rotacionar para olhar pro jogador
	if chefe1.jogador:
		chefe1.look_at(chefe1.jogador.global_position)
