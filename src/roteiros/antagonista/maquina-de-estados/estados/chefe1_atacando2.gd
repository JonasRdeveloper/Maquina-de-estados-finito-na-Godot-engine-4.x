# chefe1_atacando2.gd
class_name Estado_atacando2_boss1
extends Interface_chefe1

var chefe1: Vilao

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	print("Entrou em Atacando2")
	chefe1.area_ataque.monitoring = true
	
	# Toca animação do segundo golpe e espera
	if chefe1.anim_tree:
		chefe1.viagem.travel("Ataque_poderoso")  # State "atacando2" no Tree
		await chefe1.anim_tree.animation_finished
		# Após, volta baseado em dist
		if chefe1.jogador:
			var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
			if dist < 5.0:
				transitado.emit(self, "chefe1_atacando")  # Loop se ainda perto?
			elif dist < 12.0:
				transitado.emit(self, "chefe1_correndo")
			else:
				transitado.emit(self, "chefe1_andando")

func sair() -> void:
	print("Saiu de Atacando2")
	chefe1.area_ataque.monitoring = false

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	chefe1.velocity = Vector3.ZERO
	if chefe1.jogador:
		chefe1.look_at(chefe1.jogador.global_position, Vector3.UP)
