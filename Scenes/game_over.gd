extends Control
@onready var animation_player = $AnimationPlayer
@onready var restart_btn = $VBoxContainer/restart_btn


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	animation_player.play("reveal")
	#restart_btn.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_btn_pressed():
	await LevelTransition.fade_to_black()
	Globals.player_continues = 0
	LevelTransition.fade_from_black()
	get_tree().change_scene_to_file(Globals.current_level)


func _on_quit_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	LevelTransition.fade_from_black()


func _on_levels_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/level_select_screen.tscn")
#	Globals.player_continues = 3
	LevelTransition.fade_from_black()
