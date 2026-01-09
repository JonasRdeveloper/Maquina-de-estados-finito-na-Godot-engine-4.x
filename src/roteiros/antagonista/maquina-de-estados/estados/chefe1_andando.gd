# chefe1_andando.gd
class_name Estado_andando_boss1
extends Interface_chefe1

const PROTAGONISTA_ANDANDO = preload("res://src/recursos/Protagonista_andando.tres")

var chefe1: Vilao

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	var cor_da_malha := chefe1.get_node("MeshInstance") as MeshInstance3D
	cor_da_malha.mesh.surface_set_material(0, PROTAGONISTA_ANDANDO)
	print("Entrou em Andando")

func sair() -> void:
	print("Saiu de Andando")

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	if chefe1.jogador:
		var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
		if dist < 5.0:
			transitado.emit(self, "Chefe1_atacando")
		elif dist < 12.0 and dist > 8.0:  # Distância ideal para correr
			transitado.emit(self, "Chefe1_correndo")
		elif dist > 20.0:
			transitado.emit(self, "Chefe1_ocioso")

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	# Movimento de patrulha simples (ex: em direção ao jogador devagar)
	if chefe1.jogador:
		var direcao = (chefe1.jogador.global_position - chefe1.global_position).normalized()
		chefe1.velocity = direcao * chefe1.velocidade
	else:
		chefe1.velocity = Vector3.ZERO
