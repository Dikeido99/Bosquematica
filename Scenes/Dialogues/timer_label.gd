extends Label

func _process(delta):
#	if DialogManager.answer_box.answer_time.get_time_left() <= 5:
#		set_text(str((QuizManager.answer_box.answer_time.get_time_left()) + 1).pad_decimals(0))
		set_text(str((Globals.quiz_time)))
