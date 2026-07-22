extends Area2D
class_name Bubble

var speed : float
var velocity: Vector2

func _ready() -> void:
	area_entered.connect(_on_area_2d_bubble_area_entered)
	input_event.connect(_on_area_2d_bubble_input_event)
	velocity = Vector2(randf_range(-1.0,1.0),randf_range(-1.0,1.0))
	speed = randf_range(50.0,200.0) /scale.x
	
func _physics_process(delta: float) -> void:
	position += velocity * speed * delta
	
func _on_area_2d_bubble_area_entered(area: Area2D) -> void:
	print("Inter bubble collision")
	var opposite_vector : Vector2 = (global_position - area.global_position).normalized()
	velocity = opposite_vector
		
func _on_area_2d_bubble_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Bubble clicked")
		queue_free()


	
