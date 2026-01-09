# interface_chefe1.gd
class_name Interface_chefe1
extends Node

@warning_ignore("unused_signal")
signal transitado(estado_origem: Interface_chefe1, novo_nome_estado: String)

# Chamado ao entrar no estado
@warning_ignore("unused_parameter")
func entrar(ref_personagem: Vilao) -> void:
	pass  # Implemente lógica de entrada, ex: animações, resets

# Chamado ao sair do estado
func sair() -> void:
	pass  # Implemente cleanup, ex: parar animações

# Lógica por frame (não-física, ex: checar condições de transição)
@warning_ignore("unused_parameter")
func atualizar(delta: float) -> void:
	pass  # Ex: checar se jogador está perto e transitar

# Lógica física por frame (ex: movimento, colisões)
@warning_ignore("unused_parameter")
func atualizar_fisica(delta: float) -> void:
	pass  # Ex: calcular velocity e aplicar
