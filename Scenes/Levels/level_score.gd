extends CanvasLayer

var next_level = PackedScene
@onready var next_btn = $menu_holder/next_btn
var failed_attempts := 0
@onready var credits_btn = $menu_holder/credits_btn
@onready var select_btn = $menu_holder/select_btn
@onready var quit_btn = $menu_holder/quit_btn

@onready var continues_counter = $score_holder/continues_holder/continues_counter
@onready var quiz_counter = $score_holder/quiz_holder/quiz_counter
@onready var time_counter = $score_holder/time_holder/time_counter
@onready var final_score_counter = $final_score_container/final_score_counter

@onready var label_lvl_complete = $label_lvl_complete
@onready var label_substract = $label_substract
@onready var label_sum = $label_sum
@onready var label_multiply = $label_multiply
@onready var label_divide = $label_divide
@onready var label_square = $label_square

@onready var theme = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	failed_attempts = Globals.quiz_attempts - Globals.quiz_score
	operation()
	if Globals.game_data["game_already_finished"] == 0:
		if Globals.game_data["game_completed"] == 0:
			if not next_level is PackedScene:
				next_btn.visible = false
			else:
				next_btn.visible = true
		elif Globals.game_data["game_completed"] == 1:
			label_lvl_complete.text = "Has Completado el Juego!"
			next_btn.visible = false
			select_btn.visible = false
			quit_btn.visible = false
			credits_btn.visible = true
	else:
		if not next_level is PackedScene:
			next_btn.visible = false
		else:
			next_btn.visible = true
#	pass

func operation():
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
	#if Globals.current_operation_lvl == "sum":
		#label_sum.text = "SUMA - NIVEL " + str(Globals.current_level_number)
		#label_sum.visible = true
	#elif Globals.current_operation_lvl == "sub":
		#label_substract.text = "RESTA - NIVEL " + str(Globals.current_level_number)
		#label_substract.visible = true
	#elif Globals.current_operation_lvl == "mul":
		#label_multiply.text = "MULTIPLICA - NIVEL " + str(Globals.current_level_number)
		#label_multiply.visible = true
	#elif Globals.current_operation_lvl == "div":
		#label_divide.text = "DIVIDE - NIVEL " + str(Globals.current_level_number)
		#label_divide.visible = true
	#elif Globals.current_operation_lvl == "sqr":
		#label_square.text = "RAIZ CUADRADA - NIVEL " + str(Globals.current_level_number)
		#label_square.visible = true

func _on_next_btn_pressed():
	theme.stop()
	await LevelTransition.fade_to_black()
	Globals.player_continues = 0
	get_tree().change_scene_to_packed(next_level)
	#get_tree().paused = false
	LevelTransition.fade_from_black()


func _on_select_btn_pressed():
	theme.stop()
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/level_select_screen.tscn")	
	#get_tree().paused = false
	LevelTransition.fade_from_black()


func _on_quit_btn_pressed():
	theme.stop()
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	#get_tree().paused = false
	LevelTransition.fade_from_black()


func _on_credits_btn_pressed():
	theme.stop()
	if Globals.game_data["game_already_finished"] == 0:
		Globals.game_data["game_already_finished"] = 1
		Globals.save_database()
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/credits_screen.tscn")
	LevelTransition.fade_from_black()
