# chefe1_atacando1.gd
class_name Estado_atacando1_boss1
extends Interface_chefe1

var chefe1: Vilao

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	print("Entrou em Atacando1")
	chefe1.area_ataque.monitoring = true
	
	# Toca animação do primeiro golpe e espera terminar
	if chefe1.viagem:
		chefe1.viagem.travel("Atacando_fraco")  # State "atacando1" no Tree
		await chefe1.anim_tree.animation_finished
		# Após animação, transita pro segundo golpe
		transitado.emit(self, "chefe1_atacando2")

func sair() -> void:
	print("Saiu de Atacando1")
	chefe1.area_ataque.monitoring = false

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	# Dano já gerenciado pelo signal no Vilao
	pass

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	chefe1.velocity = Vector3.ZERO
	if chefe1.jogador:
		chefe1.look_at(chefe1.jogador.global_position, Vector3.UP)
