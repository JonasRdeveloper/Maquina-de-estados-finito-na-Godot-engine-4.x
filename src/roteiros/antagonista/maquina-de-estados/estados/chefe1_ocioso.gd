# chefe1_ocioso.gd
class_name Estado_ocioso_boss1
extends Interface_chefe1

var chefe1: Vilao

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	print("Entrou em Ocioso")
	# Blend vai pro -1.0 automaticamente via animate()

func sair() -> void:
	print("Saiu de Ocioso")

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	if chefe1.jogador:
		var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
		if dist < 8.0:
			transitado.emit(self, "chefe1_correndo")
		elif dist < 15.0:
			transitado.emit(self, "chefe1_andando")

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	chefe1.velocity = Vector3.ZERO  # Para, blend vai pro idle suave
