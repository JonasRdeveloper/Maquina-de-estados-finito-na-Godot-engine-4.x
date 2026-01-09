# maquina_de_estados.gd
extends Node
class_name MaquinaDeEstados

@export var estado_inicial: Node  # Arraste um estado filho no Inspector

var estado_atual: Interface_chefe1
var estados: Dictionary = {}  # nome_minusculo -> node

@onready var ref_personagem: Vilao = $".."  # Pai (Vilao)

func _ready() -> void:
	# Coleta estados filhos
	for filho in get_children():
		if filho is Interface_chefe1:
			var nome_minusculo = filho.name.to_lower()
			estados[nome_minusculo] = filho
			filho.transitado.connect(ao_transitar_estado_filho)
	
	# Inicia no estado inicial com delay para readiness
	if estado_inicial and estado_inicial is Interface_chefe1:
		await get_tree().create_timer(0.1).timeout
		estado_inicial.entrar(ref_personagem)
		estado_atual = estado_inicial
	else:
		push_error("Estado inicial não definido ou inválido!")

func _process(delta: float) -> void:
	if estado_atual:
		estado_atual.atualizar(delta)

func _physics_process(delta: float) -> void:
	if estado_atual:
		estado_atual.atualizar_fisica(delta)

func ao_transitar_estado_filho(estado_origem: Interface_chefe1, novo_nome_estado: String) -> void:
	if estado_origem != estado_atual:
		return  # Segurança contra signals antigos
	
	var nome_minusculo = novo_nome_estado.to_lower()
	var novo_estado: Interface_chefe1 = estados.get(nome_minusculo)
	if not novo_estado:
		push_error("Estado '" + novo_nome_estado + "' não encontrado!")
		return
	
	# Sai do atual
	estado_atual.sair()
	
	# Entra no novo
	novo_estado.entrar(ref_personagem)
	
	# Atualiza
	estado_atual = novo_estado
