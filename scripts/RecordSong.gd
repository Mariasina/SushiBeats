extends Node

# Referência aos nós
var audio_player
var timer
onready var time = $time
onready var a_label = $A
onready var s_label = $S
onready var d_label = $D

# Variáveis para gravação
var recording = false
var start_time = 0
var events = []
var color = Color(1, 0, 0)

func _process(delta):
	time.set_text(str(timer.get_time_left()))

func _ready():
	audio_player = $AudioStreamPlayer
	timer = $Timer
	
	
	# Configurar tempo do timer
	timer.wait_time = 0.1  # Ajuste o intervalo de gravação se necessário

	# Certifique-se de que a música não está em loop
	audio_player.stream.loop = false
	start_time = 0

func _input(event):
	# Apenas gravar se uma tecla for pressionada
	if event.is_action_pressed("hit_A") or event.is_action_pressed("hit_S") or event.is_action_pressed("hit_D"):
		if not recording:
			print("Iniciando gravação...")
			start_recording()

		# A gravação já está acontecendo, então gravamos o evento
		if event.is_action_pressed("hit_A"):
			record_event("A")
			print("A")
			a_label.set("theme_override_colors/font_color", color)
		elif event.is_action_pressed("hit_S"):
			record_event("S")
			print("S")            
			s_label.set("theme_override_colors/font_color", color)
		elif event.is_action_pressed("hit_D"):
			record_event("D")
			print("D")            
			d_label.set("theme_override_colors/font_color", color)
	else:
		reset_label_colors()

func reset_label_colors():
	a_label.set("theme_override_colors/font_color", Color(1, 1, 1))
	s_label.set("theme_override_colors/font_color", Color(1, 1, 1))
	d_label.set("theme_override_colors/font_color", Color(1, 1, 1))

func start_recording():
	if not recording:
		print("Gravação iniciada e música tocando!")
		start_time = OS.get_ticks_msec()
		recording = true
		audio_player.play()
		timer.start()

func record_event(key):
	var current_time = (OS.get_ticks_msec() - start_time) / 1000.0
	events.append({"key": key, "time": current_time})

# Função que é chamada quando a música termina
func _on_AudioStreamPlayer_finished():
	print("Música terminada, parando gravação...")
	stop_recording()

func stop_recording():
	if recording:
		recording = false
		timer.stop()
		audio_player.stop()
		save_events_to_file()

func save_events_to_file():
	var file = File.new()
	if file.open("res://scripts/level_data.txt", File.WRITE) == OK:
		for event in events:
			file.store_line(str(event["time"]) + "," + event["key"])
		file.close()
	else:
		print("Erro ao abrir o arquivo para gravação.")
