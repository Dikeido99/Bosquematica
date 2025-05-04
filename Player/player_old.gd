extends CharacterBody2D

@export var movement_data : PlayerMovementData

var direction := 0.0

@onready var sprite := $AnimatedSprite2D
@onready var remoteTransform2D := $RemoteTransform2D
@onready var coyote_jump_timer := $CoyoteJumpTimer

func _physics_process(delta):
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	
	direction = Input.get_axis("ui_left","ui_right")
	
	velocity.x = direction * movement_data.speed
	
	if direction != 0:
		sprite.play("move")
	else:
		sprite.play("idle")
	
	sprite.flip_h = direction < 0 if direction != 0 else sprite.flip_h
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y -= movement_data.jump
	
	
	if !is_on_floor():
		velocity.y += movement_data.gravity
		sprite.play("jump")
	

func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path
