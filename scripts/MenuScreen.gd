extends CanvasLayer

onready var transition = $transition

func _ready():
	#transition.connect("finished", self, "_on_transition_finished")
	transition.stream.loop = false # Desativa o loop diretamente no código, se não tiver certeza da configuração

func _process(delta):
	if Input.is_action_just_pressed("hit"):
		transition.play()
		SceneTransition.change_scene("res://scenes/playSong.tscn")
		  # Desativa _process para garantir que o som toque apenas uma vez

func _on_transition_finished():  
	pass

