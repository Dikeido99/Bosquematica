extends Control
@onready var back_btn = $VBoxContainer/back_btn


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	Globals.current_operation_lvl = ""
	Globals.current_level_number = 0
	if not TitleScreenTheme.is_playing():
		TitleScreenTheme.play()
	#back_btn.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	LevelTransition.fade_from_black()
