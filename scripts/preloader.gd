extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hossomaki_cucumber_mesh = preload("res://assets/models/foodItems/sushi/hossomakiCocumber.glb")
var hossomaki_cucumber_slim_mesh = preload("res://assets/models/foodItems/sushi/hossomakiCocumberSlim.glb")
var hossomaki_salmon_mesh = preload("res://assets/models/foodItems/sushi/hossomakiSalmon.glb")
var hossomaki_salmon_slim_mesh = preload("res://assets/models/foodItems/sushi/hossomakiSalmonSlim.glb")
var hossomaki_tuna_mesh = preload("res://assets/models/foodItems/sushi/hossomakiTuna.glb")
var hossomaki_tuna_slim_mesh = preload("res://assets/models/foodItems/sushi/hossomakiTunaSlim.glb")
var nigiri_base_mesh = preload("res://assets/models/foodItems/sushi/niguiriBase.glb")
var nigiri_salmon_mesh = preload("res://assets/models/foodItems/sushi/niguiriSalmon.glb")
var nigiri_salmon_nori_mesh = preload("res://assets/models/foodItems/sushi/niguiriSalmonWithNori.glb")
var nigiri_shrimp_mesh = preload("res://assets/models/foodItems/sushi/niguiriShrimp.glb")
var nigiri_shrimp_white_fish_mesh = preload("res://assets/models/foodItems/sushi/niguiriShrimpWhiteFish.glb")
var nigiri_shrimp_white_fish_nori_mesh = preload("res://assets/models/foodItems/sushi/niguiriShrimpWhiteFishWithNori.glb")
var nigiri_shrimp_nori_mesh = preload("res://assets/models/foodItems/sushi/niguiriShrimpWithNori.glb")
var nigiri_tamago_mesh = preload("res://assets/models/foodItems/sushi/niguiriTamago.glb")
var nigiri_tamago_nori_mesh = preload("res://assets/models/foodItems/sushi/niguiriTamagoWithNori.glb")
var nigiri_tuna_mesh = preload("res://assets/models/foodItems/sushi/niguiriTuna.glb")
var nigiri_tuna_nori_mesh = preload("res://assets/models/foodItems/sushi/niguiriTunaWithNori.glb")
var uramaki_cucumber_mesh = preload("res://assets/models/foodItems/sushi/uramakiCocumber.glb")
var uramaki_dragon_mesh = preload("res://assets/models/foodItems/sushi/uramakiDragon.glb")
var uramaki_salmon_mesh = preload("res://assets/models/foodItems/sushi/uramakiSalmon.glb")
var uramaki_tuna_mesh = preload("res://assets/models/foodItems/sushi/uramakiTuna.glb")

var sushi_meshes = []

func _ready():
	sushi_meshes = [
	hossomaki_cucumber_mesh,
	hossomaki_cucumber_slim_mesh,
	hossomaki_salmon_mesh,
	hossomaki_salmon_slim_mesh,
	hossomaki_tuna_mesh,
	hossomaki_tuna_slim_mesh,
	nigiri_base_mesh,
	nigiri_salmon_mesh,
	nigiri_salmon_nori_mesh,
	nigiri_shrimp_mesh,
	nigiri_shrimp_white_fish_mesh,
	nigiri_shrimp_white_fish_nori_mesh,
	nigiri_shrimp_nori_mesh,
	nigiri_tamago_mesh,
	nigiri_tamago_nori_mesh,
	nigiri_tuna_mesh,
	nigiri_tuna_nori_mesh,
	uramaki_cucumber_mesh,
	uramaki_dragon_mesh,
	uramaki_salmon_mesh,
	uramaki_tuna_mesh
]



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
