# chefe1_andando.gd
class_name Estado_andando_boss1
extends Interface_chefe1

var chefe1: Vilao

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	print("Entrou em Andando")
	# Blend vai pro 0.0 via animate()

func sair() -> void:
	print("Saiu de Andando")

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	if not chefe1.jogador:
		transitado.emit(self, "chefe1_ocioso")
		return
	
	var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
	if dist < 2.0:
		transitado.emit(self, "chefe1_atacando")
	elif dist < 10.0:
		transitado.emit(self, "chefe1_correndo")
	elif dist > 20.0:
		transitado.emit(self, "chefe1_ocioso")

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	if chefe1.jogador:
		var direcao = (chefe1.jogador.global_position - chefe1.global_position)
		direcao.y = 0
		direcao = direcao.normalized()
		
		# Mantém gravidade no eixo Y
		chefe1.velocity.x = direcao.x * chefe1.velocidade
		chefe1.velocity.z = direcao.z * chefe1.velocidade
	else:
		chefe1.velocity.x = 0.0
		chefe1.velocity.z = 0.0
