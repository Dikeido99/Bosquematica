extends Control
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var animation_tree = $AnimationTree.get("parameters/playback")
@onready var start_btn = $MarginContainer/HBoxContainer/VBoxContainer/start_btn


# Called when the node enters the scene tree for the first time.
func _ready():
	#Globals.Load_Data()
	Globals.load_database()	
	get_tree().paused = false
	if not TitleScreenTheme.is_playing():
		TitleScreenTheme.play()
	animation_player.play("reveal")
	#start_btn.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/level_select_screen.tscn")
	LevelTransition.fade_from_black()


func _on_quit_btn_pressed():
	Globals.player_id = 0
	Globals.game_data["sum_level_completed"] = 0
	Globals.game_data["sub_level_completed"] = 0
	Globals.game_data["mul_level_completed"] = 0
	Globals.game_data["div_level_completed"] = 0
	Globals.game_data["sqr_level_completed"] = 0
	Globals.game_data["game_completed"] = 0
	Globals.game_data["game_already_finished"] = 0
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/login_screen.tscn")
	LevelTransition.fade_from_black()
	#get_tree().quit()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "reveal":
		animation_tree.travel("loop")


func _on_credits_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/credits_screen.tscn")
	LevelTransition.fade_from_black()


func _on_instructions_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/instructions_screen.tscn")
	LevelTransition.fade_from_black()


func _on_scores_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/leaderboard_screen.tscn")
	LevelTransition.fade_from_black()
