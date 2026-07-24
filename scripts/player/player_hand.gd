extends Node2D
class_name Hand

@onready var area: Area2D = %Area

const rest_pos := Vector2(1265, 707)

var curr_target: Node2D

func _process(delta: float) -> void:
	#var updated_scale : float = min(1.0+Global.bubble_per_seconds/100.0, 5.0)
	#scale  = Vector2(updated_scale, updated_scale)
	set_area_position(get_global_mouse_position())
	
	if curr_target == null:
		var rest_to_cursor := get_global_mouse_position() - rest_pos
		%HandPivot.rotation = Util.decayf(%HandPivot.rotation, -rest_to_cursor.angle_to(Vector2.UP), 8 * delta)
		%HandPivot.position = Util.decayv2(%HandPivot.position, rest_pos, 10 * delta)
	else:
		%HandPivot.rotation = curr_target.rotation
		%HandPivot.position = Util.decayv2(%HandPivot.position, curr_target.position, 45 * delta)
	
	if Input.is_action_just_pressed("left_click"):
		var popped := false
		for area in %Area.get_overlapping_areas():
			if area is Bubble:
				area.bubble_popped()
				popped = true
		if popped:
			move_hand_click(get_global_mouse_position())

func set_area_position(pos: Vector2):
	%Area.global_position = pos

func move_hand_click(pos: Vector2):
	var rest_to_click := pos - rest_pos
	var hand_rot := -rest_to_click.angle_to(Vector2.UP)
	var palm_to_point: Vector2 = %FingerPoint.position.rotated(hand_rot)
	var hand_pos := pos - palm_to_point
	curr_target = Node2D.new()
	curr_target.position = hand_pos
	curr_target.rotation = hand_rot
	%HandShaker.shake(1.5, 1.0)
	var timer := get_tree().create_timer(0.5, false)
	timer.timeout.connect(curr_target.queue_free)
