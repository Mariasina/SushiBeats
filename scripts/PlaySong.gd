extends Node

# Referência aos nós
var audio_player
var timer
onready var time = $time

# Variáveis para gravação
var recording = false
var start_time = 0
var events = []
var current_index = 0

var delay = 4  # 5 segundos de atraso para começar a música
var game_start_time = 0  # Armazena o tempo de início do jogo

func _process(delta):
	generate_level()

func _ready():
	audio_player = $AudioStreamPlayer
	timer = $Timer
	audio_player.stream.loop = false
	
	# Configurar tempo do timer
	timer.wait_time = 0.1

	# Carregar os eventos
	read_file()

	# Armazenar o tempo de início do jogo
	game_start_time = OS.get_ticks_msec()

	# Iniciar a geração dos beats imediatamente
	timer.start()

	# Iniciar a música após um atraso de 5 segundos
	yield(get_tree().create_timer(delay), "timeout")
	audio_player.play()

func read_file():
	var file = File.new()
	if file.open("res://scripts/level_data.txt", File.READ) == OK:
		while not file.eof_reached():
			var line = file.get_line().strip_edges()  # Remove espaços extras
			if line != "":  # Apenas processa linhas não vazias
				var parts = line.split(",")
				if parts.size() == 2:  # Verifica se existem dois valores na linha
					var event_time = float(parts[0]) * 1000  # Em milissegundos
					var key = parts[1].strip_edges()  # A tecla pressionada
					
					# Verificação adicional para garantir que o evento foi lido corretamente
					if event_time > 0:
						events.append({"time": event_time, "key": key})
						print("Evento carregado: Tempo:", event_time, "Tecla:", key)
					else:
						print("Erro: Tempo do evento não é válido:", event_time)
				else:
					print("Erro: Linha do arquivo mal formatada:", line)
		file.close()
	else:
		print("Erro ao abrir o arquivo.")

func generate_level():
	# Calcula o tempo total passado desde o início do jogo
	var current_game_time = OS.get_ticks_msec() - game_start_time

	
	# Verifica se ainda há eventos a serem processados
	while current_index < events.size():
		var event = events[current_index]
		# Se o tempo ajustado atinge o tempo do evento, processa o beat
		if current_game_time >= event["time"]:
			print("Tecla pressionada em:", event["time"], " - Tecla:", event["key"])
			match event["key"]:
				"A":
					var beat = load("res://scenes/beat.tscn").instance()
					beat.translation.x = -5
					beat.translation.z = -10
					add_child(beat)
				"S":
					var beat = load("res://scenes/beat.tscn").instance()
					beat.translation.x = 0
					beat.translation.z = -10
					add_child(beat)
				"D":
					var beat = load("res://scenes/beat.tscn").instance()
					beat.translation.x = 5
					beat.translation.z = -10
					add_child(beat)
			# Avança para o próximo evento
			current_index += 1
		else:
			break
