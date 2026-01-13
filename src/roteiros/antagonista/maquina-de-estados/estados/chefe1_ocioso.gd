class_name Estado_ocioso_boss1
extends Interface_chefe1

var chefe1: Vilao
var tempo_restante: float = 0.0
var esta_em_pausa_proxima: bool = false

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	print("Entrou em Ocioso")
	chefe1.desired_velocity = Vector3.ZERO
	if chefe1.jogador:
		var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
		if dist < 7.0:
			tempo_restante = 2.0  # Tempo de espera para o jogador se afastar (ajuste conforme necessário)
			esta_em_pausa_proxima = true
		else:
			esta_em_pausa_proxima = false
	else:
		esta_em_pausa_proxima = false

func sair() -> void:
	print("Saiu de Ocioso")
	esta_em_pausa_proxima = false
	tempo_restante = 0.0

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	if esta_em_pausa_proxima:
		if tempo_restante > 0:
			tempo_restante -= delta
			return  # Aguarda o tempo sem verificar transições
		else:
			esta_em_pausa_proxima = false  # Tempo acabou, agora pode transitar
	if chefe1.jogador:
		var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
		if dist < 8.0:
			emit_signal("transitado", self, "chefe1_correndo")
		elif dist < 30.0:
			emit_signal("transitado", self, "chefe1_andando")

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	chefe1.desired_velocity = Vector3.ZERO
