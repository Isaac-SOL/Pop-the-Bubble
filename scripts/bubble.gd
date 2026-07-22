class_name Bubble extends Node2D

signal clicked
@warning_ignore("unused_signal")
signal spawn(amount: int)

@export var spawn_on_pop: int = 0

func bubbles_per_second() -> int:
	return 0

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit()
