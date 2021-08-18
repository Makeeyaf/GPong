extends KinematicBody2D

signal on_scrored(id)

const ball_radius: float = 4.0
const ball_height: float = 2 * ball_radius
const paddle_radius: float = 32.0
const right_unit_vector = Vector2(1, 0)
const left_unit_vector = Vector2(-1, 0)
const scorable_wall: int = 16
const paddle: int = 2
const initial_speed: float = 300.0

var is_stop: bool = false
var speed: float = initial_speed
var velocity = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_stop:
		return

	var collision = move_and_collide(velocity.normalized() * speed * delta)

	if collision:
		var collider = instance_from_id(collision.collider_id) as PhysicsBody2D
		var bounce_vector = collision.normal

		if collider:
			if collider.collision_layer == scorable_wall:
				var is_left_wins: bool = _is_left_wins(collider.position.x)
				var id: String = 'left' if is_left_wins else 'right'
				emit_signal('on_scrored', id)
				reset_position()
				reset_velocity(initial_speed)
				serve(is_left_wins)
				return

			if collider.collision_layer == paddle:
				speed *= 1.1

			var contact_position: float = collider.position.y - collision.position.y - ball_radius

			if abs(contact_position) < 28:
				var span = ball_radius if contact_position > 0 else -ball_radius

				var contact_index = int((contact_position + span) / ball_height)
				if contact_index > 3:
					contact_index = 3
				elif contact_index < -3:
					contact_index = -3

				var rotation = deg2rad(-contact_index * 5)
				if abs(bounce_vector.angle()) <= deg2rad(75):
					bounce_vector = bounce_vector.rotated(rotation)

		velocity = velocity.bounce(bounce_vector)

func _is_left_wins(x: float) -> bool:
	var center_x = get_viewport_rect().size.x * 0.5
	return x > center_x

func reset_position() -> void:
	var center_point = get_viewport_rect().size / 2
	position = center_point

func reset_velocity(speed: float) -> void:
	if speed > 0:
		self.speed = speed
	else:
		self.speed = initial_speed

	self.velocity = Vector2(0, 0)

func serve(is_left_wins: bool) -> void:
	var angle: float = rand_range(-PI, PI) / 3
	velocity = Vector2(-1, 0) if is_left_wins else Vector2(1, 0)
	velocity = velocity.rotated(angle) * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
