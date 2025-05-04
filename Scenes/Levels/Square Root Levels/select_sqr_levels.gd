extends Control

@onready var level_btn_2 = $square_levels/level_btn2
@onready var level_btn_3 = $square_levels/level_btn3
@onready var level_btn_4 = $square_levels/level_btn4
@onready var level_btn_5 = $square_levels/level_btn5

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.game_data["sqr_level_completed"] > 0:
		level_btn_2.disabled = false
		if Globals.game_data["sqr_level_completed"] > 1:
			level_btn_3.disabled = false
			if Globals.game_data["sqr_level_completed"] > 2:
				level_btn_4.disabled = false
				if Globals.game_data["sqr_level_completed"] > 3:
					level_btn_5.disabled = false
