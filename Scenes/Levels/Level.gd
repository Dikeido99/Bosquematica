extends Node

@export var operation = ""
@export var lvl_number := 0

@onready var clock_timer = $Clock_Timer
@onready var camera := $Camera2D as Camera2D
@onready var player := $Player as CharacterBody2D
@onready var player_scene := preload("res://Player/player.tscn")

@onready var quiz_position = $Camera2D/Quiz_position

func _ready():
	get_tree().paused = false
	Globals.hud_visible = true
	Globals.hud_continues_counter = 4
	Globals.mobile_visible = true
	Globals.current_level = get_tree().get_current_scene().scene_file_path
	Globals.player_start_position = $Player_start_position
	Globals.player = player
	Globals.player.connect_camera(camera)
	Globals.player.player_has_died.connect(reload_level)
	Globals.player.game_over.connect(game_over)
	Globals.quiz_score = 0
	Globals.quiz_attempts = 0
	Globals.player_life = 5
	Globals.clock_minutes = 0
	Globals.clock_seconds = 0

func  _process(delta):
	Globals.quiz_position = quiz_position.global_position
	Globals.current_operation_lvl = operation
	Globals.current_level_number = lvl_number

func reload_level():
	await LevelTransition.fade_to_black()
	Globals.hud_continues_counter -= 1
	var player = player_scene.instantiate()
	add_child(player)
	Globals.player = player
	Globals.player.connect_camera(camera)
	Globals.player.player_has_died.connect(reload_level)
	Globals.player.game_over.connect(game_over)
	Globals.player_life = 5
	Globals.respawn_player()
	LevelTransition.fade_from_black()


func _on_clock_timer_timeout():
	if Globals.clock_seconds >= 59:
		Globals.clock_seconds = 0
		Globals.clock_minutes += 1
	else:
		Globals.clock_seconds += 1

func game_over():
	await LevelTransition.fade_to_black()
	LevelTransition.fade_from_black()
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
