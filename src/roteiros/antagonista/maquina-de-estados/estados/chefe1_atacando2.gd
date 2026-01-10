# chefe1_ataque_combo2.gd
class_name Estado_ataque_combo2_boss1
extends Interface_chefe1

var chefe1: Vilao
@onready var anim_player: AnimationPlayer = null
@onready var area_ataque: Area3D = null

func entrar(personagem: Vilao) -> void:
	chefe1 = personagem
	anim_player = chefe1.get_node("Anim_chefe1")
	area_ataque = chefe1.get_node("AreaAtaque_chefe1")
	print("Entrou em AtaqueCombo2")
	if anim_player:
		anim_player.play("ataque_combo2")
	if area_ataque:
		area_ataque.monitoring = true

func sair() -> void:
	print("Saiu de AtaqueCombo2")
	if area_ataque:
		area_ataque.monitoring = false

@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	# Transita de volta após animação
	if anim_player and not anim_player.is_playing():
		if chefe1.jogador:
			var dist = chefe1.global_position.distance_to(chefe1.jogador.global_position)
			if dist < 5.0:
				transitado.emit(self, "Chefe1_atacando1")  # Loop combo se ainda perto?
			elif dist < 12.0:
				transitado.emit(self, "Chefe1_correndo")
			else:
				transitado.emit(self, "Chefe1_andando")
	
	# GUARDA: Só checa bodies SE monitoring ATIVO
	if area_ataque and area_ataque.monitoring:
		for body in area_ataque.get_overlapping_bodies():
			if body.is_in_group("jogador"):
				body.vida -= 20  # Ou emita signal para dano
				print("Dano causado!")  # Debug opcional
	else:
		print("[DEBUG] Monitoring off, pulando detecção")  # Remove depois

@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	chefe1.velocity = Vector3.ZERO
	if chefe1.jogador:
		chefe1.look_at(chefe1.jogador.global_position, Vector3.UP)
