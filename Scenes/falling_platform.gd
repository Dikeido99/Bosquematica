extends AnimatableBody2D

@onready var animationtree = $AnimationTree.get("parameters/playback")

func _on_activation_body_entered(body):
	if body.is_on_floor():
		animationtree.travel("falling")
