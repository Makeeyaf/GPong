extends Node2D

export var id: String

func _ready() -> void:
	update_score(0)

func update_score(score: int) -> void:
	var label = get_child(0) as Label
	if label:
		label.text = String(score)

func _on_pong_on_scored(id, value) -> void:
	if self.id == id:
		update_score(value)
