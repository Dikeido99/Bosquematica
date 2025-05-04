extends StaticBody2D

@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var collision_shape_2d = $CollisionShape2D as CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	collision_shape_2d.shape.size = sprite_2d.get_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
