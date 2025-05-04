extends StaticBody2D


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()
		if QuizManager.dialog_box != null:
			QuizManager.dialog_box.queue_free()
			QuizManager.is_message_active = false
			if QuizManager.answer_box != null:
				QuizManager.answer_box.queue_free()
				QuizManager.timer_label.queue_free()
			QuizManager.current_line = 0
			QuizManager.quiz_finished.emit()
