extends Area2D

@onready var sprite := $AnimatedSprite2D
@export var next_level = PackedScene
@onready var level_score = $level_score

var time_points = 0
var quiz_points = 0 
var continues_points = 0
var final_score = 0
var qualification_score
var save_score

var date
var day
var month
var year

func _ready():
	sprite.play("default")

func _on_body_entered(body):
	if not body.get_name() == "Player": return
	if Globals.quiz_score != 5 : return
	elif Globals.quiz_score == 5:
		var date = Time.get_date_dict_from_system()
		get_tree().paused = true
		Globals.hud_visible = false
		Globals.mobile_visible = false
		unlock_level()
		level_score.next_level = next_level
		level_score.visible = true
		level_score.theme.play()
		calculate_score()
		show_score()
		save_score = {
			"player_id" : Globals.player_id,
			"operation" : Globals.current_operation_lvl,
			"level_num" : Globals.current_level_number,
			"continue_score" : level_score.continues_counter.text,
			"error_quiz_score" : level_score.quiz_counter.text,
			"time_score" : level_score.time_counter.text,
			"final_score" : final_score,
			"qualy_score" : level_score.final_score_counter.text,
			"date" : str("%02d" % date["day"]) + "/" + str("%02d" % date["month"]) + "/" + str(date["year"])}
		Globals.score_database(save_score)
		Globals.save_database()

func unlock_level():
	if Globals.current_operation_lvl == "sum":
			if Globals.game_data["sum_level_completed"] < Globals.current_level_number: 
				Globals.game_data["sum_level_completed"] = Globals.current_level_number
			else:
				Globals.game_data["sum_level_completed"] = Globals.game_data["sum_level_completed"]
	elif Globals.current_operation_lvl == "sub":
			if Globals.game_data["sub_level_completed"] < Globals.current_level_number:
				Globals.game_data["sub_level_completed"] = Globals.current_level_number
			else:
				Globals.game_data["sub_level_completed"]= Globals.game_data["sub_level_completed"]
	elif Globals.current_operation_lvl == "mul":
			if Globals.game_data["mul_level_completed"] < Globals.current_level_number: 
				Globals.game_data["mul_level_completed"] = Globals.current_level_number 
			else:
				Globals.game_data["mul_level_completed"] = Globals.game_data["mul_level_completed"] 
	elif Globals.current_operation_lvl == "div":
			if Globals.game_data["div_level_completed"] < Globals.current_level_number: 
				Globals.game_data["div_level_completed"] = Globals.current_level_number
			else:
				Globals.game_data["div_level_completed"] = Globals.game_data["div_level_completed"] 
	elif Globals.current_operation_lvl == "sqr":
			if Globals.game_data["sqr_level_completed"] < Globals.current_level_number: 
				Globals.game_data["sqr_level_completed"] = Globals.current_level_number 
			else:
				Globals.game_data["sqr_level_completed"] = Globals.game_data["sqr_level_completed"] 
	
	if Globals.game_data["sum_level_completed"] == 5 and Globals.game_data["sub_level_completed"] == 5 and Globals.game_data["mul_level_completed"]== 5 and Globals.game_data["div_level_completed"] == 5:
		if Globals.game_data["game_already_finished"] == 0:
			Globals.game_data["game_completed"] = 1
		else:
			return

func calculate_score():
		if level_score.failed_attempts == 0:
			quiz_points += 10
		elif level_score.failed_attempts == 1:
			quiz_points += 9
		elif level_score.failed_attempts == 2:
			quiz_points += 8
		elif level_score.failed_attempts == 3:
			quiz_points += 7
		elif level_score.failed_attempts == 4:
			quiz_points += 6
		elif level_score.failed_attempts == 5:
			quiz_points += 5
		elif level_score.failed_attempts == 6:
			quiz_points += 4
		elif level_score.failed_attempts == 7:
			quiz_points += 3
		elif level_score.failed_attempts == 8:
			quiz_points += 2
		elif level_score.failed_attempts >= 9:
			quiz_points += 1
		
		
		if Globals.clock_minutes < 1:
			time_points += 10
		elif Globals.clock_minutes == 1:
			if Globals.clock_seconds <= 45:
				time_points += 10
			else:
				time_points += 8
		elif Globals.clock_minutes == 2:
			time_points += 5
		elif Globals.clock_minutes == 3:
			time_points += 3
		elif Globals.clock_minutes == 4:
			time_points += 2
		elif Globals.clock_minutes >= 5:
			time_points += 1
		
		if Globals.player_continues == 0:
			continues_points += 3
		elif Globals.player_continues == 1:
			continues_points += 2
		elif Globals.player_continues == 2:
			continues_points += 2
		elif Globals.player_continues == 3:
			continues_points += 1
		elif Globals.player_continues == 4:
			continues_points += 0
		
		final_score = continues_points + time_points + quiz_points
		if final_score == 23:
			qualification_score = "A+"
		elif final_score >= 18:
			qualification_score = "A"
		elif final_score >= 13:
			qualification_score = "B"
		elif final_score >= 8:
			qualification_score = "C"
		elif final_score >= 3:
			qualification_score = "D"
		elif final_score <= 2:
			qualification_score = "F" 
		
	

func show_score():
		level_score.quiz_counter.text = str("%02d" % level_score.failed_attempts)
		if quiz_points == 10:
			level_score.quiz_counter.add_theme_color_override("font_color", "Cyan")
		elif quiz_points >= 7:
			level_score.quiz_counter.add_theme_color_override("font_color", "Green")
		elif quiz_points >= 4:
			level_score.quiz_counter.add_theme_color_override("font_color", "Yellow")
		elif quiz_points >= 2 :
			level_score.quiz_counter.add_theme_color_override("font_color", "Orange")
		elif quiz_points == 1 :
			level_score.quiz_counter.add_theme_color_override("font_color", "Red")
			
			
		level_score.time_counter.text = str("%02d" % Globals.clock_minutes) + ":" + str("%02d" % Globals.clock_seconds)
		if time_points == 10:
			level_score.time_counter.add_theme_color_override("font_color", "Cyan")
		elif time_points == 8:
			level_score.time_counter.add_theme_color_override("font_color", "Green")
		elif time_points == 5:
			level_score.time_counter.add_theme_color_override("font_color", "Yellow")
		elif time_points == 3:
			level_score.time_counter.add_theme_color_override("font_color", "Orange")
		elif time_points <= 2:
			level_score.time_counter.add_theme_color_override("font_color", "Red")
		
		level_score.continues_counter.text = str("%02d" % Globals.player_continues)
		if continues_points == 3:
			if time_points == 10 and quiz_points == 10:
				level_score.continues_counter.add_theme_color_override("font_color", "Cyan")
			else: 
				level_score.continues_counter.add_theme_color_override("font_color", "Green")
		elif continues_points == 2:
			level_score.continues_counter.add_theme_color_override("font_color", "Yellow")
		elif continues_points == 1:
			level_score.continues_counter.add_theme_color_override("font_color", "Orange")
		elif continues_points == 0 :
			level_score.continues_counter.add_theme_color_override("font_color", "Red")
		
		level_score.final_score_counter.text = qualification_score
		if qualification_score == "A+":
			level_score.final_score_counter.add_theme_color_override("font_color", "Cyan")
		if qualification_score == "A":
			level_score.final_score_counter.add_theme_color_override("font_color", "Green")
		if qualification_score == "B":
			level_score.final_score_counter.add_theme_color_override("font_color", "Yellow")
		if qualification_score == "C" or qualification_score == "D":
			level_score.final_score_counter.add_theme_color_override("font_color", "Orange")
		if qualification_score == "F":
			level_score.final_score_counter.add_theme_color_override("font_color", "Red")
		
