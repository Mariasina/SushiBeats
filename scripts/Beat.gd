extends Node

var player_in_area = false
var player_body = null  # Variável para armazenar o corpo do jogador
var speed = 6
export var key_associated = ""  # Variável para armazenar a tecla associada ao beat
export var is_touching = false  # Indica se o beat está em contato com o BeatWall
var models = []
var glb_folder_path = "res://assets/models/foodItems/sushi"
var food_node # Referência ao CSGMesh
onready var sushiHit = $sushiHit

signal beat_hit(beat)

func _ready():
	food_node = $Food
	load_all_glb_meshes_from_folder()
	
	# Definir uma mesh aleatória no Food quando o beat for instanciado
	if models.size() > 0:
		var num = random_num()
		#print(num)
		set_food_mesh_from_array(num)


func _process(delta):
	self.translation.z += speed * delta
	
	# Só destrói o beat se a tecla associada foi pressionada e o beat está em contato com o BeatWall
	if Input.is_action_just_pressed(key_associated) and is_touching:
		sushiHit.play()
		print("Tecla correta pressionada:", key_associated)

		emit_signal("beat_hit", self)  # Emitir o sinal com referência ao beat
		queue_free()  # Destrói o beat

# Método chamado quando o beat entra em contato com o BeatWall
func _on_Area_body_entered(area):
	if area.is_in_group("BeatWall"):
		is_touching = true  
	if area.is_in_group("BorderWall"):
		Global.misses += 1
		print("BorderWall detectado! Misses: ", Global.misses)
		queue_free()

# Método chamado quando o beat sai de contato com o BeatWall
func _on_Area_body_exited(area):
	if area.is_in_group("BeatWall"):
		is_touching = false

func load_all_glb_meshes_from_folder():
	var dir = Directory.new()
	
	# Abre a pasta e verifica se é válida
	if dir.open(glb_folder_path) == OK:
		#print("Pasta aberta com sucesso:", glb_folder_path)
		dir.list_dir_begin()  # Inicia a leitura dos arquivos no diretório
		var file_name = dir.get_next()
		
		while file_name != "":
			#print("Verificando arquivo:", file_name)

			# Ignora diretórios e arquivos que não são .glb
			if !dir.current_is_dir() and file_name.ends_with(".glb"):
				var scene_path = glb_folder_path + "/" + file_name
				var scene = load(scene_path) as PackedScene
				if scene:
					# Instancia a cena e obtém o MeshInstance
					#print(file_name.replace('.glb', ''))
					var instance = scene.instance()
					var mesh_instance = instance.get_node(file_name.replace('.glb', ''))  # Ajuste o nome se necessário

					# Adiciona a mesh extraída na array glb_meshes
					if mesh_instance and mesh_instance.mesh:
						models.append(mesh_instance.mesh)
						#print("Mesh adicionada da cena: " + file_name)
					else:
						print("Erro: o arquivo .glb não contém uma mesh")
				else:
					print("Erro ao carregar: " + file_name)

			file_name = dir.get_next()  # Próximo arquivo na pasta

		dir.list_dir_end()  # Finaliza a leitura da pasta
	else:
		print("Erro ao abrir a pasta:", glb_folder_path)


# Função para definir uma mesh da array no CSGMesh Food
func set_food_mesh_from_array(index):
	if index >= 0 and index < models.size():
		food_node.mesh = models[index]
		#print("Mesh definida para o CSGMesh Food do índice: " + str(index))
	else:
		print("Índice fora do limite da array")

func random_num():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(0, models.size() -1)
