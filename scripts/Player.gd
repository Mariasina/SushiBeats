extends KinematicBody

var swipe_jump = 4.5
var curr_position = 0
var score = 0
var original_color = Color(1, 1, 1)  # Declaração de original_color na classe

func _ready():
	var mesh_instance = $MeshInstance
	if mesh_instance:
		var material = mesh_instance.get_surface_material(0)
		if not material:
			material = SpatialMaterial.new()
			mesh_instance.set_surface_material(0, material)
		original_color = material.albedo_color  # Atribui a cor original do material
	else:
		print("MeshInstance não encontrado!")

func _process(delta): 
	self.translation.z = curr_position
	self.translation.x += 0.15
	
	if Input.is_action_just_pressed("swipe_left"):
		if curr_position > -swipe_jump:
			curr_position -= swipe_jump
	if Input.is_action_just_pressed("swipe_right"):
		if curr_position < swipe_jump:
			curr_position += swipe_jump

func change_color(new_color: Color):
	var mesh_instance = $MeshInstance
	if mesh_instance:
		var material = mesh_instance.get_surface_material(0)
		if material and material is SpatialMaterial:
			material.albedo_color = new_color
		else:
			print("Material não encontrado ou não é um SpatialMaterial!")
	else:
		print("MeshInstance não encontrado!")
