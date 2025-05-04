extends LineEdit

var regex = RegEx.new()
var oldtext = ""
@onready var text_sound = $"../../Text_sound"

# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()
	regex.compile("^[0-9]*$")	

func _process(delta):
		grab_focus()

func _on_text_changed(new_text):
	text_sound.play()
	if regex.search(new_text):
		text = new_text   
		oldtext = text
		set_caret_column(text.length())
	else:
		text = oldtext
		set_caret_column(text.length())
