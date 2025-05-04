extends Area2D


func _on_body_entered(body):
	if body.get_name() == "Player":
		body.velocity.y = body.movement_data.jump_velocity
		body.hit_sound.play()
		owner.anim.play("hit")
		#body.queue_free()
		#await LevelTransition.fade_to_black()
		#LevelTransition.fade_from_black()
		#get_tree().reload_current_scene()
