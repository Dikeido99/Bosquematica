extends Path2D

enum ANIMATION_TYPE {
	LOOP,
	BOUNCE
}

@export var animation_type : ANIMATION_TYPE
@export var animation_speed : float = 1.0 : set = set_speed

@onready var animationPlayer := $AnimationPlayer

@onready var sprite = $PathFollow2D/Enemy/AnimatedSprite2D

func _ready():
	sprite.play("idle")
	match animation_type:
		ANIMATION_TYPE.LOOP: animationPlayer.play("MoveAlongPathLoop")
		ANIMATION_TYPE.BOUNCE: animationPlayer.play("MoveAlongPathBounce")

func set_speed(value):
	animation_speed = value
	var ap = get_node("AnimationPlayer")
	if ap: ap.speed_scale = animation_speed
