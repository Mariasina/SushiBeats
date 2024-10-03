extends CSGPolygon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		print("goal")
		get_tree().change_scene("res://scenes/screens/score.tscn")
