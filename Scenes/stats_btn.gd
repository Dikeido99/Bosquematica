extends Button

@export var score_scene : PackedScene
@export var level_number : int
@export var operation_lvl : String


func _ready():
	
	Globals.database.select_rows("levels", "player_id = '" + str(Globals.player_id) + "' AND operation = '" +
	str(operation_lvl) + "' AND level_num = '" + str(level_number) + "'", ["*"])
	
	for i in Globals.database.query_result:
		text = i.qualy_score
	
	if text == "A+":
		add_theme_color_override("font_color", "Cyan")
	elif text == "A":
		add_theme_color_override("font_color", "Green")
	elif text == "B":
		add_theme_color_override("font_color", "Yellow")
	elif text == "C" or text == "D":
		add_theme_color_override("font_color", "Orange")
	elif text == "F":
		add_theme_color_override("font_color", "Red")
	else:
		add_theme_color_override("font_color", "Gray")


func _on_pressed():
	Globals.current_operation_lvl = operation_lvl
	Globals.current_level_number = level_number
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_packed(score_scene)
	LevelTransition.fade_from_black()
