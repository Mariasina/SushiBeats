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
var beats_in_contact = []

var delay = 4  # 5 segundos de atraso para começar a música
var game_start_time = 0  # Armazena o tempo de início do jogo

func _process(delta):
	generate_level()
	# Verifica se há beats armazenados e se a tecla correta foi pressionada
	for beat in beats_in_contact:
		if Input.is_action_just_pressed(beat.key_associated) and beat.is_touching:
			print("Tecla correta pressionada:", beat.key_associated)
			beats_in_contact.erase(beat)  # Remove o beat da lista de colisão
			beat.queue_free()  # Destrói o beat de forma segura

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
						#print("Evento carregado: Tempo:", event_time, "Tecla:", key)
					else:
						print("Erro: Tempo do evento não é válido:", event_time)
				else:
					print("Erro: Linha do arquivo mal formatada:", line)
		file.close()
	else:
		print("Erro ao abrir o arquivo.")

func generate_level():
	var current_game_time = OS.get_ticks_msec() - game_start_time

	while current_index < events.size():
		var event = events[current_index]
		if current_game_time >= event["time"]:
			var beat = load("res://scenes/beat.tscn").instance()

			# Posicionar o beat conforme a tecla associada
			match event["key"]:
				"A":
					beat.translation.x = -5
					beat.translation.z = -10
					beat.key_associated = "hit_A"
				"S":
					beat.translation.x = 0
					beat.translation.z = -10
					beat.key_associated = "hit_S"
				"D":
					beat.translation.x = 5
					beat.translation.z = -10
					beat.key_associated = "hit_D"

			# Adicionar o beat à cena
			add_child(beat)
			current_index += 1
		else:
			break


func _on_beat_in_contact(beat):
	# Adiciona o beat à lista de contato apenas se ainda não estiver nela
	if beats_in_contact.has(beat) == false:
		beats_in_contact.append(beat)
		print("Beat armazenado em contato com o BeatWall")

func _on_beat_out_of_contact(beat):
	# Remove o beat da lista de contato quando ele sai da colisão
	if beats_in_contact.has(beat):
		beats_in_contact.erase(beat)
		print("Beat removido do contato com o BeatWall")

func _on_AudioStreamPlayer_finished():
	get_tree().change_scene("res://scenes/screens/score.tscn")
