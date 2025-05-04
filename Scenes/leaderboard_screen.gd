extends Control

var ranked_1 = {
	"name" = "-",
	"score" = 0}
var ranked_2 = {
	"name" = "-",
	"score" = 0}
var ranked_3 = {
	"name" = "-",
	"score" = 0}
var ranked_4 = {
	"name" = "-",
	"score" = 0}
var ranked_5 = {
	"name" = "-",
	"score" = 0}

@onready var player_1 = $Player_container/player_1
@onready var player_2 = $Player_container/player_2
@onready var player_3 = $Player_container/player_3
@onready var player_4 = $Player_container/player_4
@onready var player_5 = $Player_container/player_5

@onready var score_1 = $Score_container/score_1
@onready var score_2 = $Score_container/score_2
@onready var score_3 = $Score_container/score_3
@onready var score_4 = $Score_container/score_4
@onready var score_5 = $Score_container/score_5

@onready var rank_1 = $Rank_container/rank_1
@onready var rank_2 = $Rank_container/rank_2
@onready var rank_3 = $Rank_container/rank_3
@onready var rank_4 = $Rank_container/rank_4
@onready var rank_5 = $Rank_container/rank_5

@onready var gamer_name_lbl = $gamer_name_lbl
@onready var gamer_score_lbl = $gamer_score_lbl


func _ready():
	get_data()
	show_data()
	calculate_player()

func get_data():
	var array = []
	#Globals.database.query("SELECT name, SUM(final_score) as 'total_score'
		#FROM
		#players
		#INNER JOIN levels on players.id = levels.player_id
		#GROUP BY name
		#ORDER BY 'total_score' ASC
		#LIMIT 5")
	Globals.database.query("SELECT name, SUM(final_score) as 'total_score'
		FROM
		players
		INNER JOIN levels on players.id = levels.player_id
		GROUP BY name
		ORDER BY SUM(final_score) DESC
		LIMIT 5")
	array = Globals.database.query_result
	if array.size() == 1:
		ranked_1["name"] = array[0].name
		ranked_1["score"] = array[0].total_score
	elif array.size() == 2:
		ranked_1["name"] = array[0].name
		ranked_1["score"] = array[0].total_score
		ranked_2["name"] = array[1].name
		ranked_2["score"] = array[1].total_score
	elif array.size() == 3:
		ranked_1["name"] = array[0].name
		ranked_1["score"] = array[0].total_score
		ranked_2["name"] = array[1].name
		ranked_2["score"] = array[1].total_score
		ranked_3["name"] = array[2].name
		ranked_3["score"] = array[2].total_score
	elif array.size() == 4:
		ranked_1["name"] = array[0].name
		ranked_1["score"] = array[0].total_score
		ranked_2["name"] = array[1].name
		ranked_2["score"] = array[1].total_score
		ranked_3["name"] = array[2].name
		ranked_3["score"] = array[2].total_score
		ranked_4["name"] = array[3].name
		ranked_4["score"] = array[3].total_score
	elif array.size() == 5:
		ranked_1["name"] = array[0].name
		ranked_1["score"] = array[0].total_score
		ranked_2["name"] = array[1].name
		ranked_2["score"] = array[1].total_score
		ranked_3["name"] = array[2].name
		ranked_3["score"] = array[2].total_score
		ranked_4["name"] = array[3].name
		ranked_4["score"] = array[3].total_score
		ranked_5["name"] = array[4].name
		ranked_5["score"] = array[4].total_score
	else:
		return

func show_data():
	player_1.text = ranked_1["name"]
	score_1.text = str(ranked_1["score"])
	player_2.text = ranked_2["name"]
	score_2.text = str(ranked_2["score"])
	player_3.text = ranked_3["name"]
	score_3.text = str(ranked_3["score"])
	player_4.text = ranked_4["name"]
	score_4.text = str(ranked_4["score"])
	player_5.text = ranked_5["name"]
	score_5.text = str(ranked_5["score"])

func calculate_player():
	var array = []
	Globals.database.query("SELECT ifnull(name,'NULL') as 'name', SUM(final_score) as 'total_score'
		FROM
		players
		INNER JOIN levels on players.id = levels.player_id
		WHERE players.id = '" + str(Globals.player_id) + "'")
	
	
	for i in Globals.database.query_result:
		if i.name == 'NULL':
			Globals.database.select_rows("players", "id = '" + str(Globals.player_id) + "'",["name"])
			for j in Globals.database.query_result:
				gamer_name_lbl.text = j.name
				gamer_score_lbl.text = str(0)
		else:
			gamer_name_lbl.text = i.name
			gamer_score_lbl.text = str(i.total_score)

func _on_back_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	LevelTransition.fade_from_black()
