extends Node

@onready var dialog_box_scene = preload("res://Scenes/Dialogues/quiz_box.tscn")
@onready var answer_box_scene = preload("res://Scenes/Dialogues/answer_box.tscn")
@onready var no_answer_body_scene = preload("res://Scenes/Dialogues/no_answer_body.tscn")
@onready var timer_label_scene = preload("res://Scenes/Dialogues/timer_label.tscn")

var message_lines : Array[String] = []
var current_line = 0

var dialog_box
var dialog_box_position := Vector2.ZERO
var answer_box
var timer_label
var no_answer_body
var no_answer_body_position

var is_message_active := false
var can_advance_message := false
var answered_quiz := false
var completed_quiz := false
var time_is_over := false

signal quiz_finished()

func start_message(position : Vector2, lines : Array[String] ):
	if is_message_active:
		return
	
	message_lines = lines
	dialog_box_position = Globals.quiz_position
	no_answer_body_position = position
	if current_line == 0:
		InteractionManager.show_touchscreen = false
		Globals.quiz_attempts += 1
	show_text()
	is_message_active = true

func show_text():
	dialog_box = dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	get_tree().root.add_child(dialog_box)
	dialog_box.global_position = dialog_box_position
	dialog_box.display_text(message_lines[current_line])
	can_advance_message = false

func _on_all_text_displayed():
	if current_line == 0:
		show_answer_box()
		answer_box.answer_time.start()
	elif current_line == 1:
		failed_quiz()
	can_advance_message = true

func show_answer_box():
	answer_box = answer_box_scene.instantiate()
	answer_box.entered_answer.connect(_on_answered_quiz)
	answer_box.time_over.connect(_on_time_over)
	get_tree().root.add_child(answer_box)
	answer_box.position.x = dialog_box.position.x + 80
	answer_box.position.y = dialog_box.position.y + 20
	show_timer() 

func show_timer():
	timer_label = timer_label_scene.instantiate()
	get_tree().root.add_child(timer_label)
	timer_label.position.x = answer_box.position.x + 45
	timer_label.position.y = answer_box.position.y

func _on_answered_quiz():
	answered_quiz = true

func _on_time_over():
	time_is_over = true
	if(is_message_active && can_advance_message && !answered_quiz && time_is_over):
		failed_quiz()
		time_is_over = false

func failed_quiz():
		no_answer_body = no_answer_body_scene.instantiate()
		get_tree().root.add_child(no_answer_body)
		no_answer_body.global_position = no_answer_body_position
#Aqui se procesa la respuesta introducida por el jugador
func _unhandled_input(event):
	if(event.is_action_pressed("interact") && is_message_active && can_advance_message && !answered_quiz):
		if current_line != 0:
			dialog_box.queue_free()
			is_message_active = false
			current_line = 0
			quiz_finished.emit()
	#Una vez que el jugador ha respondido, se analiza su respuesta
	if(is_message_active && can_advance_message && answered_quiz):
		dialog_box.queue_free()
		answer_box.queue_free()
		timer_label.queue_free()
		#El jugador ha respondido correctamente
		if Globals.answer == (Globals.result):
			current_line = 2 #Avanza al mensaje correcto
			answered_quiz = false
			Globals.quiz_score += 1 #Se le suma un punto
			show_text()
			dialog_box.correct_sound.play()
			InteractionManager.show_touchscreen = true
			completed_quiz = true #Ha completado el problema matemático
		#Caso contrario, ha respondido incorrectamente
		else:
			current_line = 1
			answered_quiz = false
			InteractionManager.show_touchscreen = false
			show_text()
