extends Node2D


enum {HOVER,FALL, LAND, RISE }

var state = HOVER

@onready var start_position = global_position
@onready var timer := $Timer
@onready var raycast := $RayCast2D
#@onready var anim := $AnimatedSprite2D
@onready var anim = $AnimationPlayer

func _physics_process(delta):
	match state:
		HOVER: hover_state()
		FALL: fall_state(delta)
		LAND: land_state()
		RISE: rise_state(delta)
	

func hover_state():
	state = FALL

func fall_state(delta):
#	anim.play("falling")
	position.y += 160 * delta
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		position.y =  collision_point.y
		state = LAND
		timer.start(1.0)

func land_state():
	if timer.time_left == 0:
		state = RISE

func rise_state(delta):
#	anim.play("rising")
	position.y = move_toward(position.y, start_position.y, 50 * delta)
	if position.y == start_position.y :
		state = HOVER


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hit":
		anim.play("idle")
