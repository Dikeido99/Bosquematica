extends CanvasLayer

@onready var resume_btn = $menu_holder/resume_btn

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and get_tree().paused != true:# and QuizManager.dialog_box == null:
		if QuizManager.dialog_box != null and QuizManager.current_line == 0:
			QuizManager.dialog_box.visible = false
			if QuizManager.answer_box != null:
				QuizManager.answer_box.visible = false
				QuizManager.timer_label.visible = false
		Globals.mobile_visible = false
		visible = true
		get_tree().paused = true
		#resume_btn.grab_focus()

func _on_resume_btn_pressed():
	if QuizManager.dialog_box != null and QuizManager.current_line == 0:
		QuizManager.dialog_box.visible = true
		if QuizManager.answer_box != null:
			QuizManager.answer_box.visible = true
			QuizManager.timer_label.visible = true
	Globals.mobile_visible = true
	visible = false
	get_tree().paused = false


func _on_quit_btn_pressed():
	await LevelTransition.fade_to_black()
	#get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	LevelTransition.fade_from_black()
#	get_tree().quit()
