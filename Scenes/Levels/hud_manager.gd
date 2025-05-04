extends Control

#@onready var life_counter = $container/life_container/life_counter as Label
@onready var score_counter = $container/score_container/score_counter as Label
@onready var time_counter = $container/time_container/time_counter as Label
@onready var life_counter = $container/VBoxContainer/life_container/life_counter as Label
@onready var continue_counter = $container/VBoxContainer/continue_container/continue_counter
@onready var sum_sprt = $container/score_container/sum_sprt
@onready var sub_sprt = $container/score_container/sub_sprt
@onready var mul_sprt = $container/score_container/mul_sprt
@onready var div_sprt = $container/score_container/div_sprt
@onready var sqr_sprt = $container/score_container/sqr_sprt


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.current_operation_lvl == "sum":
		sum_sprt.visible = true
	elif Globals.current_operation_lvl == "sub":
		sub_sprt.visible = true
	elif Globals.current_operation_lvl == "mul":
		mul_sprt.visible = true
	elif Globals.current_operation_lvl == "div":
		div_sprt.visible = true
	elif Globals.current_operation_lvl == "sqr":
		sqr_sprt.visible = true
	
	if Globals.hud_visible == false:
		get_parent().visible = false
	else:
		get_parent().visible = true
	continue_counter.text = str("%02d" % Globals.hud_continues_counter)
	life_counter.text = str("%02d" % Globals.player_life) 
	score_counter.text = str(Globals.quiz_score) + " de 5"
	time_counter.text = str("%02d" % Globals.clock_minutes) + ":" + str("%02d" % Globals.clock_seconds) 
	if Globals.quiz_score == 5:
		score_counter.add_theme_color_override("font_color", "Green")
	
	if Globals.hud_continues_counter == 0:
		continue_counter.add_theme_color_override("font_color", "Red")
	else:
		continue_counter.add_theme_color_override("font_color", "White")
	
	if Globals.player_life == 0:
		life_counter.add_theme_color_override("font_color", "Red")
	else:
		life_counter.add_theme_color_override("font_color", "White")
