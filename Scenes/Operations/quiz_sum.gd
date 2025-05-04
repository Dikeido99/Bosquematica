extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var interaction_area = $interaction_area
@onready var animation_player = $AnimationPlayer

var lines : Array[String]  
@export var range_a1 = 10.0
@export var range_a2 = 100.0
@export var range_b1 = 10.0
@export var range_b2 = 100.0

@export var num_unity = 1

var random = RandomNumberGenerator.new()


#Cuando es llamada a la escena
func _ready():
#	Globals.quiz_time = 12
	interaction_area.interact = Callable(self, "_on_interact")
#Cuando el jugador interactua con el problema de suma
func _on_interact():
	Globals.quiz_time = 15
	
	random.randomize()
	
	Globals.num1 = random.randi_range(range_a1,range_a2) * num_unity
	Globals.num2 = random.randi_range(range_b1,range_b2) * num_unity
	
	Globals.result = Globals.num1 + Globals.num2
	#Los mensajes que apareceran.
	lines = [
		"Cuánto es?\n" + str(Globals.num1) + " +\n" + str(Globals.num2), #Problema matemático de suma
		"Eso es Incorrecto!", #Mensaje en caso de respuesta correcta
		"Correcto! Es: " + str(Globals.result) #Mensaje en caso de respuesta incorrecta
	]
	QuizManager.start_message(global_position, lines) #Se pasan los argumentos para la construcción del globo de texto
	await QuizManager.quiz_finished #Se espera a la señal de que el problema ha terminado.
	if QuizManager.completed_quiz:
		animation_player.play("completed")
		QuizManager.completed_quiz = false
		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "completed":
		queue_free()
