extends Node

var database : SQLite


var player_id

var current_level
var current_operation_lvl
var current_level_number

var game_data = {
	"sum_level_completed" = 0,
	"sub_level_completed" = 0,
	"mul_level_completed" = 0,
	"div_level_completed" = 0,
	"sqr_level_completed" = 0,
	"game_completed" = 0,
	"game_already_finished" = 0
	}


var player = null
var player_start_position = null
var current_checkpoint = null

var player_continues := 0
var player_life := 5
var clock_minutes := 0
var clock_seconds := 0
var quiz_score := 0
var quiz_attempts := 0

var hud_continues_counter := 4
var hud_visible := true
var mobile_visible := true

var quiz_position
var num1
var num2
var result
var answer
var quiz_time

func respawn_player():
	if current_checkpoint != null :
		player.global_position = current_checkpoint.global_position
	else:
		player.global_position =  player_start_position.global_position

func open_database():
	database = SQLite.new()
	database.path = "user://data.db"
	
	var table_players = {
		"id" : {"data_type" : "int", "primary_key" : true, "not_null" : true, "auto_increment" : true},
		"name" : {"data_type" : "text"},
		"password" : {"data_type" : "text"}}
	
	var table_game_data = {
		"player_id" : {"data_type" : "int"},
		"sum_level_completed" : {"data_type" : "int"},
		"sub_level_completed" : {"data_type" : "int"},
		"mul_level_completed" : {"data_type" : "int"},
		"div_level_completed" : {"data_type" : "int"},
		"sqr_level_completed" : {"data_type" : "int"},
		"game_completed" : {"data_type" : "int"},
		"game_already_finished" : {"data_type" : "int"}}
	
	var table_level_score = {
		"player_id" : {"data_type" : "int"},
		"operation" : {"data_type" : "text"},
		"level_num" : {"data_type" : "int"},
		"continue_score" : {"data_type" : "text"},
		"error_quiz_score" : {"data_type" : "text"},
		"time_score" : {"data_type" : "text"},
		"final_score" : {"data_type" : "int"},
		"qualy_score" : {"data_type" : "text"},
		"date" : {"data_type" : "text"}}
	
	if FileAccess.file_exists("user://data.db"):
		database.open_db()
	else:
		database.path = "user://data.db"
		database.open_db()
		
		database.create_table("players", table_players)
		database.create_table("progress", table_game_data)
		database.create_table("levels", table_level_score)

func load_database():
	var array = []
	database.select_rows("progress", "player_id = '" + str(player_id) + "'" , ["*"])
	array = database.query_result
	if array.is_empty():
		var new_game_data = {
			"player_id" = player_id,
			"sum_level_completed" = 0,
			"sub_level_completed" = 0,
			"mul_level_completed" = 0,
			"div_level_completed" = 0,
			"sqr_level_completed" = 0,
			"game_completed" = 0,
			"game_already_finished" = 0
			}
		database.insert_row("progress", new_game_data)
		
	else:
		for i in database.query_result:
			game_data["sum_level_completed"] = i.sum_level_completed
			game_data["sub_level_completed"] = i.sub_level_completed
			game_data["mul_level_completed"] = i.mul_level_completed
			game_data["div_level_completed"] = i.div_level_completed
			game_data["sqr_level_completed"] = i.sqr_level_completed
			game_data["game_completed"] = i.game_completed
			game_data["game_already_finished"] = i.game_already_finished

func save_database():
	database.update_rows("progress", "player_id = '" + str(player_id) + "'", game_data)

func score_database(level_score : Dictionary):
	var array = []
	database.select_rows("levels", "player_id = '" + str(player_id) + "' AND operation = '" +
		str(current_operation_lvl) + "' AND level_num = '" + str(current_level_number) + "'", ["*"])
	array = database.query_result
	if array.is_empty():
		database.insert_row("levels",level_score)
	else:
		for i in database.query_result:
			if level_score["final_score"] > i.final_score:
				database.update_rows("levels", "player_id = '" + str(player_id) + "' AND operation = '" +
				str(current_operation_lvl) + "' AND level_num = '" + str(current_level_number) + "'", level_score)
			else:
				return
		
