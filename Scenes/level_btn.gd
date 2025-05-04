extends Button

@export var level = PackedScene
#@export var operation = ""
#@export var lvl_number := 0

func _on_pressed():
	if not level is PackedScene: return
	TitleScreenTheme.stop()
	await LevelTransition.fade_to_black()
	Globals.player_continues = 0
	#Globals.current_operation_lvl = operation
	#Globals.current_level_number = lvl_number
	get_tree().change_scene_to_packed(level)
	LevelTransition.fade_from_black()
