extends Control

@onready var label_sum = $label_sum
@onready var label_substract = $label_substract
@onready var label_multiply = $label_multiply
@onready var label_divide = $label_divide

@onready var continues_counter = $score_holder/continues_holder/continues_counter
@onready var quiz_counter = $score_holder/quiz_holder/quiz_counter
@onready var time_counter = $score_holder/time_holder/time_counter
@onready var final_score_counter = $final_score_container/final_score_counter

@onready var bg_sum = $bg_sum
@onready var bg_sub = $bg_sub
@onready var bg_mul = $bg_mul
@onready var bg_div = $bg_div
@onready var date_label = $date_container/date_label

func _ready():
	Globals.database.select_rows("levels", "player_id = '" + str(Globals.player_id) + "' AND operation = '" +
	str(Globals.current_operation_lvl) + "' AND level_num = '" + str(Globals.current_level_number) + "'", ["*"])
	for i in Globals.database.query_result:
		continues_counter.text = i.continue_score
		time_counter.text = i.time_score
		quiz_counter.text = i.error_quiz_score
		final_score_counter.text = i.qualy_score
		date_label.text = i.date
	operation_label()
	

func operation_label():
	var current_level_name = ""
	if Globals.current_operation_lvl == "sum":
		if Globals.current_level_number == 1:
			current_level_name = "CENTENAS"
		elif Globals.current_level_number == 2:
			current_level_name = "MILES"
		elif Globals.current_level_number == 3:
			current_level_name = "DIEZ MILES"
		elif Globals.current_level_number == 4:
			current_level_name = "CIEN MILES 1"
		elif Globals.current_level_number == 5:
			current_level_name = "CIEN MILES 2"
		label_sum.text = "SUMA - " + str(Globals.current_level_number) + " : " + current_level_name
		label_sum.visible = true
		bg_sum.visible = true
	elif Globals.current_operation_lvl == "sub":
		if Globals.current_level_number == 1:
			current_level_name = "CENTENAS"
		elif Globals.current_level_number == 2:
			current_level_name = "MILES"
		elif Globals.current_level_number == 3:
			current_level_name = "DIEZ MILES"
		elif Globals.current_level_number == 4:
			current_level_name = "CIEN MILES 1"
		elif Globals.current_level_number == 5:
			current_level_name = "CIEN MILES 2"
		label_substract.text = "RESTA - " + str(Globals.current_level_number) + " : " + current_level_name
		label_substract.visible = true
		bg_sub.visible = true
	elif Globals.current_operation_lvl == "mul":
		if Globals.current_level_number == 1:
			current_level_name = "DECENAS"
		elif Globals.current_level_number == 2:
			current_level_name = "CENTENAS 1"
		elif Globals.current_level_number == 3:
			current_level_name = "CENTENAS 2"
		elif Globals.current_level_number == 4:
			current_level_name = "MILES 1"
		elif Globals.current_level_number == 5:
			current_level_name = "MILES 2"
		label_multiply.text = "MULTIPLICA - " + str(Globals.current_level_number) + " : " + current_level_name
		label_multiply.visible = true
		bg_mul.visible = true
	elif Globals.current_operation_lvl == "div":
		if Globals.current_level_number == 1:
			current_level_name = "DECENAS"
		elif Globals.current_level_number == 2:
			current_level_name = "CENTENAS 1"
		elif Globals.current_level_number == 3:
			current_level_name = "CENTENAS 2"
		elif Globals.current_level_number == 4:
			current_level_name = "MILES 1"
		elif Globals.current_level_number == 5:
			current_level_name = "MILES 2"
		label_divide.text = "DIVIDE - " + str(Globals.current_level_number) + " : " + current_level_name
		label_divide.visible = true
		bg_div.visible = true
	
	if final_score_counter.text == "A+":
		final_score_counter.add_theme_color_override("font_color", "Cyan")
	if final_score_counter.text == "A":
		final_score_counter.add_theme_color_override("font_color", "Green")
	if final_score_counter.text == "B":
		final_score_counter.add_theme_color_override("font_color", "Yellow")
	if final_score_counter.text == "C" or final_score_counter.text == "D":
		final_score_counter.add_theme_color_override("font_color", "Orange")
	if final_score_counter.text == "F":
		final_score_counter.add_theme_color_override("font_color", "Red")

func _on_back_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/level_select_screen.tscn")
	LevelTransition.fade_from_black()
