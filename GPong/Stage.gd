extends Node2D


enum State {
	initial,
	prepare,
	playing,
}


var left_score: int = 0
var right_score: int = 0
var game_state = State.initial
var timer: Timer
const match_point: int = 11
const winner_message: String = ' Wins!'
const setpoint_message: String = 'Set Point'


func _ready() -> void:
	$'Winner Message'.hide()
	_update_scores()
	randomize()


func _process(delta: float) -> void:
	if game_state != State.playing and Input.get_action_strength('ui_accept') > 0.5:
		_start_game()


func _on_Ball_on_scrored(id) -> void:
	match id:
		'left':
			left_score += 1

		'right':
			right_score += 1

	_update_scores()

	if max(left_score, right_score) == match_point:
		_end_game(id)
	elif max(left_score, right_score) == match_point - 1:
		_set_point()


func _set_point() -> void:
	$'Winner Message'.text = setpoint_message
	$'Winner Message'.show()
	$'Ball'.is_stop = true
	timer = Timer.new()
	timer.connect('timeout', self, '_on_timeout')
	timer.one_shot = true
	timer.wait_time = 2
	add_child(timer)
	timer.start(2)


func _on_timeout() -> void:
	timer.stop()
	remove_child(timer)
	_resume_game()


func _resume_game() -> void:
	$'Winner Message'.hide()
	$'Help Message'.hide()
	$'Ball'.is_stop = false


func _end_game(winner: String) -> void:
	$'Ball'.is_stop = true
	$'Winner Message'.text = winner + winner_message
	$'Winner Message'.show()
	$'Help Message'.show()
	game_state = State.prepare


func _start_game() -> void:
	left_score = 0
	right_score = 0
	_update_scores()
	_resume_game()
	$'Ball'.reset_position()
	$'Ball'.reset_velocity(0)
	$'Ball'.serve(true)
	game_state = State.playing

func _update_scores() -> void:
	$'Scores/Left Score/Label'.text = String(left_score)
	$'Scores/Right Score/Label'.text = String(right_score)
