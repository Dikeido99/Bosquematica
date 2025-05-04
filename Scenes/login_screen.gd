extends Control
@onready var player_name = $VBoxContainer/user_submit/MarginContainer/player_name
@onready var player_password = $VBoxContainer/password_submit/MarginContainer/player_password
@onready var error_message = $error_message
@onready var accept_message = $accept_message
@onready var login_timer = $login_timer
var array_name = []
var array_pass = []
@onready var login_btn = $login_btn
@onready var signin_btn = $signin_btn
@onready var quit_btn = $quit_btn

#función de cuando la ventana es llamada a la escena
func _ready():
	if not TitleScreenTheme.is_playing():
		TitleScreenTheme.play()
	Globals.open_database() #Se conecta la base de datos del juego
#Cuando se acciona el botón de salir
func _on_quit_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().quit()
#Cuando se acciona el botón de login
func _on_login_btn_pressed():
	login_btn.disabled = true
	signin_btn.disabled = true
	quit_btn.disabled = true
	if player_name.text.strip_edges(true,true) == "" or player_password.text.strip_edges(true,true) == "":
		error_message.text = "Completa los campos de texto"
		error_message.visible = true
		login_timer.start(3)
		await login_timer.timeout
		error_message.visible = false
		login_btn.disabled = false
		signin_btn.disabled = false
		quit_btn.disabled = false
	else:
		Globals.database.select_rows("players", "name = '" + player_name.text.to_lower() + "'" , ["id"] )
		array_name = Globals.database.query_result
		print(array_name)
		if array_name.is_empty():	
			error_message.text = "Usuario inexistente"
			error_message.visible = true
			login_timer.start(1)
			await login_timer.timeout
			error_message.visible = false
			login_btn.disabled = false
			signin_btn.disabled = false
			quit_btn.disabled = false
		else:
			Globals.database.select_rows("players", "name = '" + player_name.text.to_lower() + "'and password = '" + player_password.text + "'" , ["id"] )
			array_pass = Globals.database.query_result
			if array_pass.is_empty():
				error_message.text = "Contraseña Incorrecta"
				error_message.visible = true
				login_timer.start(1)
				await login_timer.timeout
				error_message.visible = false
				login_btn.disabled = false
				signin_btn.disabled = false
				quit_btn.disabled = false
			else:
				accept_message.text = "Correcto!"
				accept_message.visible = true
				login_timer.start(1)
				await login_timer.timeout
				accept_message.visible = false
				accept_message.text = "Iniciando..."
				accept_message.visible = true
				#for i in Globals.database.query_result:
				for i in array_pass:
					Globals.player_id = i.id
				login_timer.start(2)
				await login_timer.timeout
				await LevelTransition.fade_to_black()
				get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
				LevelTransition.fade_from_black()

func _on_signin_btn_pressed():
	login_btn.disabled = true
	signin_btn.disabled = true
	quit_btn.disabled = true
	if player_name.text.strip_edges(true,true) == "" or player_password.text.strip_edges(true,true) == "":
		error_message.text = "Completa los campos de texto"
		error_message.visible = true
		login_timer.start(1)
		await login_timer.timeout
		error_message.visible = false
		login_btn.disabled = false
		signin_btn.disabled = false
		quit_btn.disabled = false
	else:
		Globals.database.select_rows("players", "name = '" + player_name.text.to_lower() + "'", ["id"] )
		array_name = Globals.database.query_result
		if array_name.is_empty():
			var new_player = {
			"name" : player_name.text.to_lower(),
			"password" : player_password.text
			}
			Globals.database.insert_row("players", new_player)
			accept_message.text = "Usuario creado correctamente"
			accept_message.visible = true
			login_timer.start(1)
			await login_timer.timeout
			accept_message.visible = false
			accept_message.text = "Iniciando..."
			accept_message.visible = true
			Globals.database.select_rows("players", "name = '" + player_name.text.to_lower() + "'", ["id"] )
			for i in Globals.database.query_result:
				Globals.player_id = i.id
			login_timer.start(2)
			await login_timer.timeout
			await LevelTransition.fade_to_black()
			get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
			LevelTransition.fade_from_black()
			
		else:
			error_message.text = "Nombre de usuario no disponible"
			error_message.visible = true
			login_timer.start(1)
			await login_timer.timeout
			error_message.visible = false
			login_btn.disabled = false
			signin_btn.disabled = false
			quit_btn.disabled = false
