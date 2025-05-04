extends MarginContainer
signal time_over()
signal entered_answer()

@onready var answer_time = $Timer
@onready var timer_sound = $Timer_sound

func _on_text_edit_text_submitted(new_text):
	# Replace with function body.
	Globals.answer = int(new_text)
	entered_answer.emit()

func _on_timer_timeout():
	Globals.quiz_time -= 1
	timer_sound.play()
	if Globals.quiz_time == 0:
		time_over.emit()
