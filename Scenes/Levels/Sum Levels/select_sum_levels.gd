extends Control

@onready var level_btn_2 = $sum_levels/level_btn2
@onready var level_btn_3 = $sum_levels/level_btn3
@onready var level_btn_4 = $sum_levels/level_btn4
@onready var level_btn_5 = $sum_levels/level_btn5
@onready var stats_btn = $stats_btn
@onready var stats_btn_2 = $stats_btn2
@onready var stats_btn_3 = $stats_btn3
@onready var stats_btn_4 = $stats_btn4
@onready var stats_btn_5 = $stats_btn5


# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.game_data["sum_level_completed"] > 0:
		stats_btn.disabled = false
		level_btn_2.disabled = false
		if Globals.game_data["sum_level_completed"] > 1:
			stats_btn_2.disabled = false
			level_btn_3.disabled = false
			if Globals.game_data["sum_level_completed"] > 2:
				stats_btn_3.disabled = false
				level_btn_4.disabled = false
				if Globals.game_data["sum_level_completed"] > 3:
					stats_btn_4.disabled = false
					level_btn_5.disabled = false
					if Globals.game_data["sum_level_completed"] > 4:
						stats_btn_5.disabled = false
