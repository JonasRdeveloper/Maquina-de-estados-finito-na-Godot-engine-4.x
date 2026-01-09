# chefe1_ocioso.gd
class_name Estado_ocioso_boss1
extends Interface_chefe1

const PROTAGONISTA_OCIOSO = preload("res://src/recursos/Protagonista_ocioso.tres")

var chefe1: Vilao

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	# Ex: Tocar animação "idle"
	var cor_da_malha := chefe1.get_node("MeshInstance") as MeshInstance3D
	cor_da_malha.mesh.surface_set_material(0, PROTAGONISTA_OCIOSO)
	print("Entrou em Ocioso")

func sair() -> void:
	# Cleanup
	print("Saiu de Ocioso")

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	if chefe1.jogador:
		var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
		if dist < 8.0:  # Perto: Corre!
			transitado.emit(self, "Chefe1_correndo")
		elif dist < 15.0:  # Médio: Anda
			transitado.emit(self, "Chefe1_andando")

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	# No ocioso, velocity = 0
	chefe1.velocity = Vector3.ZERO
