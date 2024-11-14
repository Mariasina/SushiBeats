extends CPUParticles

func _ready():
	one_shot = true

func _on_Timer_timeout():
	queue_free()
