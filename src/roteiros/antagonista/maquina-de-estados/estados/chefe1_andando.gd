class_name Estado_andando_boss1
extends Interface_chefe1

var chefe1: Vilao
@export var velocidade_rotacao: float = 5.0  # Velocidade de rotação suave (ajuste conforme necessário)

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	print("Entrou em Andando")

func sair() -> void:
	print("Saiu de Andando")

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	if not chefe1.jogador:
		emit_signal("transitado", self, "chefe1_ocioso")
		return
	var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
	if dist < 7.0:
		emit_signal("transitado", self, "chefe1_ocioso")
	elif dist < 15.0:
		emit_signal("transitado", self, "chefe1_correndo")
	elif dist > 20.0:
		emit_signal("transitado", self, "chefe1_ocioso")

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	if chefe1.jogador:
		var direcao = chefe1.jogador.global_position - chefe1.global_position
		direcao.y = 0
		direcao = direcao.normalized()
		chefe1.desired_velocity = direcao * chefe1.velocidade
		if direcao != Vector3.ZERO:
			# Calcula o ângulo alvo no plano XZ
			var angulo_alvo = atan2(-direcao.x, -direcao.z)
			# Interpola suavemente a rotação no eixo Y
			chefe1.rotation.y = lerp_angle(chefe1.rotation.y, angulo_alvo, delta * velocidade_rotacao)
	else:
		chefe1.desired_velocity = Vector3.ZERO
