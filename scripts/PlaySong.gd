extends Node

var particle = preload("res://scenes/foodParticles.tscn")

# Referência aos nós
var audio_player
var timer
onready var sushicat = $Sushicat
onready var knife = $knife
onready var hundred = $hundred
onready var sushiHit = $sushiHit
onready var label_score = get_node("Control/MarginContainer/VBoxContainer/score")
onready var plate1 = get_node("Table/plate1")
onready var sushieatingcat1 = get_node("Table/sushiEatingCat1")
onready var sushieatingcat2 = get_node("Table/sushiEatingCat2")

# Variáveis para gravação
var recording = false
var start_time = 0
var events = []
var current_index = 0
var beats_in_contact = []

var delay = 4  # 5 segundos de atraso para começar a música
var game_start_time = 0  # Armazena o tempo de início do jogo
var time_delay = 0.0  # Variável para armazenar o atraso
var all_beats = 0
var total_score = 0


func _process(delta):
	label_score.text = str(Global.score)
	
	if Global.misses >= 10:
		SceneTransition.change_scene("res://scenes/screens/gameOver3d.tscn", "game_over")
		Global.misses = 0

	generate_level()
	move_beat_wall()
	knife_sound()
	control_enviroment()
	
func _ready():
	Global.score = 0
	read_file()
	all_beats = events.size()
	total_score = all_beats * 5
	
	# Calcule o atraso uma vez ao iniciar a cena
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	
	# Restante da sua função _ready, sem mudanças
	audio_player = $AudioStreamPlayer
	timer = $Timer
	audio_player.stream.loop = false
	knife.stream.loop = false
	sushiHit.stream.loop = false
	hundred.stream.loop = false

	# Configuração adicional
	timer.wait_time = 0.1
	game_start_time = OS.get_ticks_msec()
	timer.start()
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
			
			beat.connect("beat_hit", self, "_on_beat_hit")

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

func _on_AudioStreamPlayer_finished():
	SceneTransition.change_scene("res://scenes/screens/score3d.tscn")
	
func move_beat_wall():
	var frame = 0  # Definir um frame padrão
	
	for child in self.get_children():
		if child.is_in_group("BeatWallA"):
			if Input.is_action_pressed("hit_A"):
				child.translation.y = 0
				frame = 1  # Frame para tecla A
			else:
				child.translation.y = 0.5
		
		if child.is_in_group("BeatWallS"):
			if Input.is_action_pressed("hit_S"):
				child.translation.y = 0
				frame = 3  # Frame para tecla S
			else:
				child.translation.y = 0.5
				
		if child.is_in_group("BeatWallD"):
			if Input.is_action_pressed("hit_D"):
				child.translation.y = 0
				frame = 2  # Frame para tecla D
			else:
				child.translation.y = 0.5
	
	# Atualizar o frame do sushicat com o valor final
	sushicat.frame = frame

func knife_sound():
	if Input.is_action_just_pressed("hit_A") or Input.is_action_just_pressed("hit_S") or Input.is_action_just_pressed("hit_D"):
		var latency = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
		knife.play()
		yield(get_tree().create_timer(latency), "timeout")  # Aguardar pela compensação da latência


func _on_beat_hit(beat):
	Global.score += 5
	Global.misses = 0

	sushiHit.play()
	var local_particle = particle.instance()
	local_particle.translation = beat.translation
	local_particle.emitting = true
	add_child(local_particle)
	
func control_enviroment():
	if total_score == 0:
		print("Total score ainda não foi calculado.")
		return

	var percentage = float(Global.score) / float(total_score)

	print("Score:", Global.score, "Total Score:", total_score, "Percentage:", percentage)

	if percentage >= 0.1 and percentage <= 0.25:
		print("Maior q 10% e menor q 25%")
		plate1.visible = true
		sushieatingcat1.visible = true
		
	elif percentage > 0.25 and percentage <= 0.5:
		print("Maior q 25% e menor q 50%")
	elif percentage > 0.5 and percentage <= 0.75:
		print("Maior q 50% e menor q 75%")
		sushieatingcat2.visible = true
	elif percentage > 0.75 and percentage < 1:
		print("Maior q 75% e menor q 99%")
	elif percentage == 1:
		print("100%")
		hundred.play()
	else:
		print("Menor que 10% ou maior que 50%")



