extends Spatial

export(Array, PackedScene) var modules = []
var offset = 4

func _ready():
	var file_reader = load("res://scripts/FileReader.gd").new()
	var beats = file_reader.read_file()
	var count = 0

	for i in beats:
		var module_index = int(i)
		if count == 0:
			var start_scene = load("res://scenes/modules/start.tscn").instance()
			add_child(start_scene)
			start_scene.translation.x = offset
			count += 1
		elif module_index >= 0 and module_index < modules.size():
			SpawnModule(count * offset, module_index)
			count += 1
		else:
			print("Índice fora do intervalo: ", module_index)

	# Instancia a cena 'end' depois que todos os itens em 'beats' foram processados
	var end_scene = load("res://scenes/modules/end.tscn").instance()
	add_child(end_scene)
	end_scene.translation.x = count * offset  # Posicione a cena no final

func SpawnModule(n, i):
	var instance = modules[i].instance()
	instance.translation.x = n
	add_child(instance)
