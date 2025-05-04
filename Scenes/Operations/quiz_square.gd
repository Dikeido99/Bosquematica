extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var interaction_area = $interaction_area
@onready var animation_player = $AnimationPlayer

var lines : Array[String]  
@export var range_a = 9
@export var range_b = 350
var random = RandomNumberGenerator.new()
var root_num
var int_root
var remain

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	Globals.quiz_time = 12
	random.randomize()
	Globals.num1 = random.randi_range(range_a, range_b)
	root_num = sqrt(Globals.num1)
	int_root = int(root_num)
	remain = root_num - int_root
	while(remain != 0):
		Globals.num1  = random.randi_range(range_a, range_b)
		root_num = sqrt(Globals.num1)
		int_root = int(root_num)
		remain = root_num - int_root
	Globals.result = sqrt(Globals.num1)
	lines = [
		"Raíz cuadrada de " + str(Globals.num1) + " ?",
		"Esa respuesta es incorrecta!",
		"Correcto! La respuesta es: " + str(Globals.result)
	]
	QuizManager.start_message(global_position, lines)
	await QuizManager.quiz_finished
	if QuizManager.completed_quiz:
		animation_player.play("completed")
		QuizManager.completed_quiz = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "completed":
		queue_free()
