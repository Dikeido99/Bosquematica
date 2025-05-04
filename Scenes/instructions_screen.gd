extends Control

@onready var controls_tab = $controls_tab
@onready var enemies_tab = $enemies_tab
@onready var items_tab = $items_tab
@onready var controls_btn = $HBoxContainer/controls_btn


func _ready():
	if not TitleScreenTheme.is_playing():
		TitleScreenTheme.play()
	controls_btn.grab_focus()
	controls_tab.visible = true


func _on_back_btn_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	LevelTransition.fade_from_black()


func _on_controls_btn_pressed():
	controls_tab.visible = true
	enemies_tab.visible = false
	items_tab.visible = false


func _on_enemies_btn_pressed():
	controls_tab.visible = false
	enemies_tab.visible = true
	items_tab.visible = false


func _on_items_btn_pressed():
	controls_tab.visible = false
	enemies_tab.visible = false
	items_tab.visible = true
