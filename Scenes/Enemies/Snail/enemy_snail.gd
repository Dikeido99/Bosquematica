extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var Ledge = $Ledge_Check
var direction = Vector2.LEFT

func _ready():
	anim.play("run")

func _physics_process(delta):
	var found_wall = is_on_wall()
	var found_ledge = not Ledge.is_colliding() 
	
	if found_wall or found_ledge:
		direction *= -1
		scale.x *= -1
	
	velocity = direction * 15
	move_and_slide()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hit":
		queue_free()
