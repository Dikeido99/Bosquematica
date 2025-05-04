extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var interaction_area = $interaction_area
@onready var animation_player = $AnimationPlayer
var pivot
@export var range_a1 = 10
@export var range_a2 = 100
@export var range_b1 = 10
@export var range_b2 = 100

@export var num_unity = 1

var lines : Array[String]  
var random = RandomNumberGenerator.new()

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	Globals.quiz_time = 15
	
	random.randomize()
	
	Globals.num1 = random.randi_range(range_a1, range_a2)
	Globals.num2 = random.randi_range(range_b1, range_b2)
	
	while (Globals.num1 - Globals.num2 <= 1):
		Globals.num1 = random.randi_range(range_a1, range_a2)
		Globals.num2 = random.randi_range(range_b1, range_b2)
	
	Globals.num1 *= num_unity
	Globals.num2 *= num_unity
	
	Globals.result = Globals.num1 - Globals.num2
	lines = [
		"Cuánto es?\n" + str(Globals.num1) + " -\n" + str(Globals.num2),
		"Eso es Incorrecto!",
		"Correcto! Es: " + str(Globals.result)
	]
	QuizManager.start_message(global_position, lines)
	await QuizManager.quiz_finished
	if QuizManager.completed_quiz:
		animation_player.play("completed")
		QuizManager.completed_quiz = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "completed":
		queue_free()
