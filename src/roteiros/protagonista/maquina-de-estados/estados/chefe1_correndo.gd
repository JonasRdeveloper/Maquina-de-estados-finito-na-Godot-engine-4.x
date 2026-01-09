# chefe1_correndo.gd
class_name Estado_correndo_boss1
extends Interface_chefe1

const PROTAGONISTA_CORRENDO = preload("res://src/recursos/Protagonista_correndo.tres")


var chefe1: Vilao
var velocidade_corrida: float = 10.0  # Dobrada da velocidade normal (ajuste no export do Vilao)

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	print("Entrou em Correndo")
	var cor_da_malha := chefe1.get_node("MeshInstance") as MeshInstance3D
	cor_da_malha.mesh.surface_set_material(0, PROTAGONISTA_CORRENDO)
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
	if dist < 5.0:
		transitado.emit(self, "Chefe1_atacando")
	elif dist > 20.0:
		transitado.emit(self, "Chefe1_andando")

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	if chefe1.jogador:
		# Direção para o jogador, velocidade alta
		var direcao = (chefe1.jogador.global_position - chefe1.global_position).normalized()
		chefe1.velocity = direcao * velocidade_corrida  # Mais rápido que andando!
		
		# Rotaciona para mirar
		chefe1.look_at(chefe1.jogador.global_position, Vector3.UP)
	else:
		chefe1.velocity = Vector3.ZERO
