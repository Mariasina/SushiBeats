extends CanvasLayer

func change_scene(target: String, type: String = 'dissolve'):
	if type == 'dissolve':
		dissolve_transition(target)
	else: 
		game_over_transition(target)

func dissolve_transition(target: String):
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(target)
	$AnimationPlayer.play_backwards("dissolve")
	
func game_over_transition(target: String):
	$AnimationPlayer.play("GameOver")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(target)
	$AnimationPlayer.play_backwards("GameOver")
	
