# chefe1_atacando.gd
class_name Estado_atacando_boss1
extends Interface_chefe1

var chefe1: Vilao
var tempo_ataque: float = 0.0
@export var duracao_ataque: float = 1.5  # Tempo antes de iniciar combo ou voltar

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	print("Entrou em Atacando")
	tempo_ataque = 0.0
	chefe1.area_ataque.monitoring = true  # Ativa detecção de dano
	
	# Toca animação inicial de ataque
	if chefe1.anim_tree:
		chefe1.anim_tree.travel("atacando")  # Assuma state "atacando" no Tree

func sair() -> void:
	print("Saiu de Atacando")
	chefe1.area_ataque.monitoring = false  # Desativa

func atualizar(delta: float) -> void:
	tempo_ataque += delta
	if tempo_ataque > duracao_ataque:
		# Inicia combo se jogador ainda perto
		if chefe1.jogador and chefe1.global_position.distance_to(chefe1.jogador.global_position) < 5.0:
			transitado.emit(self, "chefe1_atacando1")
		else:
			transitado.emit(self, "chefe1_correndo")  # Volta perseguindo

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	chefe1.velocity = Vector3.ZERO  # Para durante ataque
	# Mira no jogador
	if chefe1.jogador:
		chefe1.look_at(chefe1.jogador.global_position, Vector3.UP)
