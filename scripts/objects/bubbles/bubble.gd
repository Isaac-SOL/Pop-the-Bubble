extends Area2D
class_name Bubble


signal clicked
@warning_ignore("unused_signal")
signal spawn(amount: int)

@onready var sprite_2d: Sprite2D = $Sprite2D


@export var bubble_level: int = 0
@export var bubble_color: Color = Color.WHITE

var shader_material : ShaderMaterial
var speed : float
var velocity: Vector2
var spawn_on_pop: int = 0

func _ready() -> void:
	sprite_2d.material = sprite_2d.material.duplicate()
	shader_material = sprite_2d.material
	area_entered.connect(_on_area_2d_bubble_area_entered)
	input_event.connect(_on_area_2d_bubble_input_event)
	scale = Vector2(1.0+bubble_level/3.0, 1.0+bubble_level/3.0)
	spawn_on_pop = 3 * bubble_level
	if bubble_color == Color.WHITE:
		match bubble_level:
			0:
				bubble_color = Color.SKY_BLUE
			1:
				bubble_color = Color.BLUE
			2:
				bubble_color = Color.DARK_BLUE
			3:
				bubble_color = Color.PALE_GREEN
			4:
				bubble_color = Color.WEB_GREEN
			5:
				bubble_color = Color.REBECCA_PURPLE
	
	shader_material.set_shader_parameter("bubble_color", bubble_color)
	shader_material.set_shader_parameter("rim_color", bubble_color+Color(0.1,0.1,0.1,0.0))
	velocity = Vector2(randf_range(-1.0,1.0),randf_range(-1.0,1.0))
	speed = randf_range(50.0,200.0) /scale.x
	
	
func _physics_process(delta: float) -> void:
	position += velocity * speed * delta
	
func bubbles_per_second() -> int:
	return 1
	
func _on_area_2d_bubble_area_entered(area: Area2D) -> void:
	if area is Bubble:
		var opposite_vector : Vector2 = (global_position - area.global_position).normalized()
		velocity = opposite_vector
		
func _on_area_2d_bubble_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit()


	
