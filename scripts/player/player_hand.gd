extends Area2D


func _process(_delta: float) -> void:
	var updated_scale : float = min(1.0+Global.bubble_per_seconds/100.0, 5.0)
	scale  = Vector2(updated_scale, updated_scale)
	global_position = get_global_mouse_position()



func _input(event):
	if event.is_action_pressed("left_click"):
		for area in get_overlapping_areas():
			if area is Bubble:
				area.bubble_popped()
