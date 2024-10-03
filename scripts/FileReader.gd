extends Node

func read_file() -> Array:
	var file = File.new()
	var path = "res://scripts/save.txt"
	file.open(path, File.READ)
	var content = file.get_as_text()
	var array = content.split("\n")
	file.close()
	return array
