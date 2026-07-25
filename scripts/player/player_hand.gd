extends Node2D
class_name Hand

@onready var area: Area2D = %Area

const rest_pos := Vector2(1265, 707)

var curr_target: Node2D
var can_click: bool = true
var pressed_time: float = 0.0
var freeze_timer: SceneTreeTimer

func _process(delta: float) -> void:
	#var updated_scale : float = min(1.0+Global.bubble_per_seconds/100.0, 5.0)
	#scale  = Vector2(updated_scale, updated_scale)
	set_area_position(get_global_mouse_position())
	
	if Input.is_action_just_pressed("left_click") and can_click:
		var popped := false
		for area in %Area.get_overlapping_areas():
			if area is Bubble:
				area.bubble_popped()
				popped = true
		if popped:
			move_hand_click(get_global_mouse_position())
	
	if Input.is_action_pressed("left_click"):
		pressed_time += delta
	else:
		pressed_time = 0.0
		if curr_target != null and (freeze_timer == null or freeze_timer.time_left <= 0.0):
			curr_target.queue_free()
	
	if pressed_time > 0.5:
		if curr_target == null:
			curr_target = Node2D.new()
		set_target_hand_transform(curr_target, get_global_mouse_position())
	
	if curr_target == null:
		var rest_to_cursor := get_global_mouse_position() - rest_pos
		%HandPivot.rotation = Util.decayf(%HandPivot.rotation, -rest_to_cursor.angle_to(Vector2.UP), 8 * delta)
		%HandPivot.position = Util.decayv2(%HandPivot.position, rest_pos, 10 * delta)
	else:
		%HandPivot.rotation = curr_target.rotation
		%HandPivot.position = Util.decayv2(%HandPivot.position, curr_target.position, 45 * delta)

func set_area_position(pos: Vector2):
	%Area.global_position = pos

func set_target_hand_transform(target: Node2D, pos: Vector2, extra_rot: float = 0.0):
	var rest_to_click := pos - rest_pos
	var hand_rot := extra_rot - rest_to_click.angle_to(Vector2.UP)
	var palm_to_point: Vector2 = %FingerPoint.position.rotated(hand_rot)
	var hand_pos := pos - palm_to_point
	target.position = hand_pos
	target.rotation = hand_rot

func move_hand_click(pos: Vector2):
	curr_target = Node2D.new()
	set_target_hand_transform(curr_target, pos)
	%HandShaker.shake(1.5, 1.0)
	freeze_timer = get_tree().create_timer(0.5, false)
	freeze_timer.timeout.connect(curr_target.queue_free)

func _on_area_area_entered(area: Area2D) -> void:
	if can_click and pressed_time > 0.5:
		if area is Bubble:
			if area.bubble_level == 0:
				area.bubble_popped()
