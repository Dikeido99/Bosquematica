extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var interaction_area = $interaction_area

@export var lines : Array[String]

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	

func _on_interact():
	DialogManager.start_message(global_position, lines)
	await DialogManager.dialog_finished
