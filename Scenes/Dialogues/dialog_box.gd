extends MarginContainer

@onready var text_label = $label_margin/text_label
@onready var letter_timer_display = $letter_timer_display
@onready var text_sound = $Text_sound
@onready var correct_sound = $Correct_sound

const MAX_WIDHT = 256

var text = ""
var letter_index = 0

var letter_display_timer := 0.07
var space_display_timer := 0.05
var punctuation_display_timer := 0.02

signal text_display_finished()

func display_text(text_to_display: String):
	text = text_to_display
	text_label.text = text_to_display
	
	await resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDHT)
	
	if size.x > MAX_WIDHT:
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	text_label.text = ""
	display_letter()
 
func display_letter():
	if letter_index < text.length():
		text_label.text += text[letter_index]
		text_sound.play()
		letter_index += 1
		
		match text[letter_index - 1]:
			"!", "?", ",", ".":
				letter_timer_display.start(punctuation_display_timer)
			" ":
				letter_timer_display.start(space_display_timer)
			_:
				letter_timer_display.start(letter_display_timer)
	else:
		text_display_finished.emit()

func _on_letter_timer_display_timeout():
	display_letter()
