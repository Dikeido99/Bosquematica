extends Area2D


func _on_body_entered(body):
	if body.get_name() == "Player":
		body.queue_free()
		if Globals.player_continues == 4:
			body.emit_signal("game_over")
		else: 
			Globals.player_continues += 1
			body.emit_signal("player_has_died")
#		Globals.quiz_score = 0
#		Globals.player_life = 5
#		get_tree().reload_current_scene()
