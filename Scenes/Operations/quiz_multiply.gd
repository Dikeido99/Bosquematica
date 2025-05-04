extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var interaction_area = $interaction_area
@onready var animation_player = $AnimationPlayer

var lines : Array[String]
var random = RandomNumberGenerator.new()  
@export var range1_a = 2
@export var range1_b = 50
@export var range2_a = 2
@export var range2_b = 12

@export var num_unity = 1

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	Globals.quiz_time = 15
	random.randomize()
	Globals.num1 = random.randi_range(range1_a, range1_b)
	Globals.num2 = random.randi_range(range2_a, range2_b)
	while Globals.num1 == 10 or Globals.num2 == 10:
		Globals.num1 = random.randi_range(range1_a, range1_b)
		Globals.num2 = random.randi_range(range2_a, range2_b)
	
	Globals.num2 = random.randi_range(range2_a, range2_b) * num_unity
	
	Globals.result = Globals.num1 * Globals.num2
	lines = [
		"Cuánto es?\n" + str(Globals.num2) + " \nx" + str(Globals.num1),
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
