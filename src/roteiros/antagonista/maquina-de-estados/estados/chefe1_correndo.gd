# chefe1_correndo.gd
class_name Estado_correndo_boss1
extends Interface_chefe1

var chefe1: Vilao
var velocidade_corrida: float = 5.0  # Dobrada da velocidade normal (ajuste no export do Vilao)

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	print("Entrou em Correndo")
	# Ex: Tocar animação "run", partículas de poeira, som de rugido

func sair() -> void:
	print("Saiu de Correndo")
	# Cleanup: Resetar animação se necessário

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	if not chefe1.jogador:
		transitado.emit(self, "Chefe1_ocioso")  # Sem jogador, volta a ocioso
		return
	
	var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
	# Se muito perto, ataca; se muito longe, para e volta a andando
	if dist < 1.0:
		transitado.emit(self, "Chefe1_atacando2")
	elif dist > 20.0:
		transitado.emit(self, "Chefe1_andando")

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	if chefe1.jogador:
		var direcao = (chefe1.jogador.global_position - chefe1.global_position)
		direcao.y = 0
		direcao = direcao.normalized()
		
		chefe1.velocity.x = direcao.x * velocidade_corrida
		chefe1.velocity.z = direcao.z * velocidade_corrida
		
		chefe1.look_at(chefe1.jogador.global_position, Vector3.UP)
	else:
		chefe1.velocity.x = 0.0
		chefe1.velocity.z = 0.0
