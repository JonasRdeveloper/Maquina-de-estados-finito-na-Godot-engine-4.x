## res://src/roteiros/antagonista/maquina-de-estados/maquina_de_estados.gd

## Esta é a máquina de estados que controla comportamentos (ex.: fases de um chefe).
## Cada "estado" é um nó filho que implementa a interface Interface_chefe1.
extends Node
class_name MaquinaDeEstados

## Estado inicial selecionável no Inspector (arraste um dos estados filhos aqui)
@export var estado_inicial: Node  # Arraste um estado filho no Inspector

## Guarda o estado que está ativo no momento (objeto que implementa Interface_chefe1)
var estado_atual: Interface_chefe1
## Dicionário que mapeia nome_minusculo -> node do estado, para buscar por nome
var estados: Dictionary = {}  # nome_minusculo -> node

## Referência ao personagem/vilão que os estados irão controlar (pai do nó da máquina)
@onready var ref_personagem: Vilao = $".."  # Pai (Vilao)

func _ready() -> void:
	## Coleta todos os filhos que implementam Interface_chefe1 e registra no dicionário
	## Também conecta o signal 'transitado' de cada estado para ouvir pedidos de troca
	for filho in get_children():
		## percorre todos os nós filhos diretos deste nó (retorna uma Array)
		if filho is Interface_chefe1:
			## verifica se o filho implementa a interface (ou é do tipo) Interface_chefe1
			var nome_minusculo = filho.name.to_lower()
			## pega o nome do nó e converte para minúsculas (usado como chave consistente)
			estados[nome_minusculo] = filho
			## armazena o nó no dicionário 'estados' usando o nome em minúsculas como chave
			## Quando o estado filho emitir 'transitado', chamamos ao_transitar_estado_filho
			filho.transitado.connect(ao_transitar_estado_filho)
			## conecta o signal 'transitado' do estado filho ao método local ao_transitar_estado_filho

	
	## Inicia no estado inicial configurado no Inspector.
	## Espera 0.1s para garantir que tudo esteja pronto (ready) antes de chamar entrar().
	if estado_inicial and estado_inicial is Interface_chefe1:
		await get_tree().create_timer(0.1).timeout
		## Chama o método entrar do estado inicial, passando a referência do personagem
		estado_inicial.entrar(ref_personagem)
		estado_atual = estado_inicial
	else:
		## Erro visível no console caso não tenha sido definido um estado inicial válido
		push_error("Estado inicial não definido ou inválido!")

func _process(delta: float) -> void:
	## Chamado a cada frame; delega atualização visual/geral ao estado atual
	if estado_atual:
		estado_atual.atualizar(delta)

func _physics_process(delta: float) -> void:
	## Chamado em passo de física; delega atualização física ao estado atual
	if estado_atual:
		estado_atual.atualizar_fisica(delta)

func ao_transitar_estado_filho(estado_origem: Interface_chefe1, novo_nome_estado: String) -> void:
	## Recebe pedidos de transição vindos dos estados filhos via signal 'transitado'
	## Segurança: ignora signals antigos se não vierem do estado atual
	if estado_origem != estado_atual:
		return  # Segurança contra signals antigos
	
	## Busca o novo estado pelo nome (case-insensitive)
	var nome_minusculo = novo_nome_estado.to_lower()
	var novo_estado: Interface_chefe1 = estados.get(nome_minusculo)
	if not novo_estado:
		## Se não encontrar, mostra erro no console para facilitar debug
		push_error("Estado '" + novo_nome_estado + "' não encontrado!")
		return
	
	## Sai do estado atual (chama método sair do estado atual)
	estado_atual.sair()
	
	## Entra no novo estado, passando a mesma referência do personagem
	novo_estado.entrar(ref_personagem)
	
	## Atualiza a referência para o estado atual
	estado_atual = novo_estado
