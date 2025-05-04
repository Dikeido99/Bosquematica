extends Area2D
class_name InteractionArea

@export var action_name : String = "interact"

var interact : Callable = func():
	pass


func _on_body_entered(body):
	InteractionManager.register_area(self)

func _on_body_exited(body):
	
	InteractionManager.show_touchscreen = false
	
	InteractionManager.unregister_area(self)
	if DialogManager.dialog_box != null:
		DialogManager.dialog_box.queue_free()
		DialogManager.is_message_active = false
		DialogManager.current_line = 0
		DialogManager.dialog_finished.emit()
	
	if QuizManager.dialog_box != null:
		QuizManager.dialog_box.queue_free()
		QuizManager.is_message_active = false
		if QuizManager.answer_box != null:
			QuizManager.answer_box.queue_free()
			QuizManager.timer_label.queue_free()
		QuizManager.current_line = 0
		QuizManager.quiz_finished.emit()
