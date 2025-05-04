extends CharacterBody2D
@onready var state_timer = $State_Timer
@onready var anim = $AnimationPlayer

#func _ready():
	#anim.play("idle")

func _on_state_timer_timeout():
	if anim.current_animation == "idle":
		anim.play("spikes_in")
	elif anim.current_animation == "idle_spikes":
		anim.play("spikes_out")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "spikes_in":
		anim.play("idle_spikes")
		state_timer.start()
	elif anim_name == "spikes_out":
		anim.play("idle")
		state_timer.start()
	elif anim_name == "hit":
		anim.play("spikes_in")
		#queue_free()
