extends CharacterBody2D

@export var movement_data : PlayerMovementData

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var knockback_vector := Vector2.ZERO
var is_hurted := false

@onready var remoteTransform2D := $RemoteTransform2D
@onready var sprite := $AnimatedSprite2D
@onready var coyote_jump_timer := $CoyoteJumpTimer
@onready var anim := $AnimationPlayer
@onready var jump_sound = $jump_sound
@onready var hurt_sound = $hurt_sound
@onready var hit_sound = $hit_sound

signal player_has_died()
signal game_over()

#función del Proceso de Físicas, la principal del jugador 
func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	

func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path
#Función que aplica la gravedad sobre el jugador.
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta

#función que se encarga de manejar las físicas del salto del jugador
func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_up"):
			jump_sound.play()
			velocity.y = movement_data.jump_velocity
	if not is_on_floor():
		if Input.is_action_just_released("ui_up") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2

#Función para manejar la aceleración
func handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

#Función para aplicar fricción
func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

#función para aplicar la resistencia del aire cuando el jugador esta suspendido en el aire
func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)

func update_animations(input_axis):
	
	var anim_state = "idle"
	
	if !is_on_floor():
		anim_state = "jump"
	elif input_axis != 0:
		anim_state = "move"
		
	if is_hurted:
		anim_state = "hurt"
		
	if anim.name != anim_state:
		anim.play(anim_state)
	
	sprite.flip_h = input_axis < 0 if input_axis != 0 else sprite.flip_h

#función  que se encarga de detectar la colisión de daño del jugador con los enemigos
func _on_hurtbox_body_entered(body):
	var knockback_direction =(global_position.x - body.global_position.x)
	if body.is_in_group("Timeout_body"):
		if not sprite.flip_h:
			wrong_answer(Vector2(-200,-150))
		elif sprite.flip_h:
			wrong_answer(Vector2(200,-150))
	elif body.is_in_group("Traps"):
		if not sprite.flip_h:
			take_damage(Vector2(-300,-200)) 
		elif sprite.flip_h:
			take_damage(Vector2(300,-200))
	elif body.is_in_group("floor_enemy"):
		if knockback_direction < 0:
			take_damage(Vector2(-250,-150))
			sprite.flip_h = false
		elif knockback_direction > 0:
			take_damage(Vector2(250,-150))
			sprite.flip_h = true
		elif knockback_direction == 0:
			if sprite.flip_h:
				take_damage(Vector2(250,-150)) 
			if not sprite.flip_h:
				take_damage(Vector2(-250,-150)) 
	elif body.is_in_group("air_enemy"):
		if knockback_direction < 0:
			take_damage(Vector2(-250,-150))
			sprite.flip_h = false
		elif knockback_direction > 0:
			take_damage(Vector2(250,-150))
			sprite.flip_h = true
		elif knockback_direction == 0:
			if sprite.flip_h:
				take_damage(Vector2(250,0)) 
			if not sprite.flip_h:
				take_damage(Vector2(-250,0)) 

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force

		var knockback_tween := get_tree().create_tween()
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		sprite.modulate = Color(1,0,0,1)
		knockback_tween.tween_property(sprite, "modulate", Color(1,1,1,1), duration)
		
	is_hurted = true
	hurt_sound.play()
	await get_tree().create_timer(.45).timeout
	if Globals.player_life == 0:
		queue_free()
		if Globals.player_continues == 4:
			emit_signal("game_over")
		else:
			Globals.player_continues += 1
			emit_signal("player_has_died")
	else:
		Globals.player_life -= 1
	is_hurted = false

func wrong_answer(knockback_force := Vector2.ZERO, duration := 0.25):
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force

		var knockback_tween := get_tree().create_tween()
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		
	is_hurted = true
	await get_tree().create_timer(.45).timeout
	is_hurted = false
