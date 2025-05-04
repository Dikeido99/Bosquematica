extends CanvasLayer
@onready var ui_interact = $Control/action/ui_interact


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if InteractionManager.show_touchscreen:
		ui_interact.visible = true
	else: 
		ui_interact.visible = false
	
	if Globals.mobile_visible == false:
		visible = false
	else:
		visible = true
