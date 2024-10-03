extends CSGSphere

onready var beat = $beat
var player_in_area = false
var player_body = null  # Variável para armazenar o corpo do jogador
var speed = 5

func _ready():
	pass

func _process(delta):
	translation.z += speed * delta
	
	if player_in_area and player_body and Input.is_action_just_pressed("swipe_left") or Input.is_action_just_pressed("swipe_middle") or Input.is_action_just_pressed("swipe_right"):
		beat.play()
		 # Atualiza o score do jogadorsd
		queue_free()  # Remove o beat 
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true
		player_body = body  # Armazena a referência ao jogador
		body.change_color(Color(1, 0, 0))  # Muda para vermelho quando colide

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false
		player_body = null  # Reseta a referência ao jogador
		body.change_color(body.original_color)  # Volta à cor original
