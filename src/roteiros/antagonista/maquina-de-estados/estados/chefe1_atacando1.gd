# chefe1_ataque_combo1.gd
class_name Estado_ataque_combo1_boss1
extends Interface_chefe1

var chefe1: Vilao
@onready var anim_player: AnimationPlayer = null  # Ajuste o path
@onready var area_ataque: Area3D = null  # Area para detectar jogador

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	anim_player = chefe1.get_node("Anim_chefe1")
	area_ataque = chefe1.get_node("AreaAtaque_chefe1")
	print("Entrou em AtaqueCombo1")
	# Toca animação do primeiro golpe
	if anim_player:
		anim_player.play("ataque_combo1")
	# Ativa detecção de dano (ex: monitoring = true)
	if area_ataque:
		area_ataque.monitoring = true

func sair() -> void:
	print("Saiu de AtaqueCombo1")
	# Desativa detecção
	if area_ataque:
		area_ataque.monitoring = false

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	# Transita para Combo2 após animação terminar (ou timer simples)
	if anim_player and not anim_player.is_playing():
		transitado.emit(self, "Chefe1_atacando2")
	
	# Causar dano se jogador na área (exemplo simples)
	for body in area_ataque.get_overlapping_bodies():
		if body.is_in_group("jogador"):
			pass
			#body.vida -= 10  # Ajuste dano; use signal para dano real

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	chefe1.velocity = Vector3.ZERO  # Para durante o ataque
	# Mira no jogador
	if chefe1.jogador:
		chefe1.look_at(chefe1.jogador.global_position, Vector3.UP)
