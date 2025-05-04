extends Control
@onready var credits = $AnimationPlayer
@onready var music = $AudioStreamPlayer

func _ready():
	get_tree().paused = false
	if Globals.game_data["game_completed"] == 1:
		credits.play("final_credits")
	else:
		credits.play("menu_credits")
	if credits.current_animation == "menu_credits":
		if not TitleScreenTheme.is_playing():
			TitleScreenTheme.play()
	elif credits.current_animation == "final_credits":
		TitleScreenTheme.stop()
		music.play()

func _on_back_btn_pressed():
	if music.is_playing():
		music.stop()
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	LevelTransition.fade_from_black()


func _on_audio_stream_player_finished():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	LevelTransition.fade_from_black()
