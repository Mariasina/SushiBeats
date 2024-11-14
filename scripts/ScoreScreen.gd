extends CanvasLayer

onready var label_score = get_node("Control/MarginContainer/VBoxContainer/score")
onready var transition = $transition

func _ready():
	transition.connect("finished", self, "_on_transition_finished")
	transition.stream.loop = false # Desativa o loop diretamente no código, se não tiver certeza da configuração

func _process(delta):
	label_score.text = str(Global.score)
	if Input.is_action_just_pressed("hit"):
		transition.play()
		  # Desativa _process para garantir que o som toque apenas uma vez

func _on_transition_finished():
	SceneTransition.change_scene("res://scenes/screens/menu3d.tscn")
