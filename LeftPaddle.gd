extends KinematicBody2D


var speed: float = 13
var velocity = Vector2.ZERO

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var input = Vector2.ZERO
	input.y = Input.get_action_strength('left_down') - Input.get_action_strength('left_up')
	velocity = input * speed
	move_and_collide(velocity)
