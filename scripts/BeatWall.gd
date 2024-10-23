extends CSGBox

var original_color = Color(1, 1, 1)  # Declaração de original_color na classe

func _ready():
	# Acessa o material do CSGPolygon
	var material = get_material()
	if not material:
		material = SpatialMaterial.new()
		set_material(material)
	original_color = material.albedo_color  # Armazena a cor original do material

func change_color(new_color: Color):
	# Acessa o material do CSGPolygon
	var material = get_material()
	if material and material is SpatialMaterial:
		material.albedo_color = new_color  # Muda a cor para a nova cor especificada
	else:
		print("Material não encontrado ou não é um SpatialMaterial!")
