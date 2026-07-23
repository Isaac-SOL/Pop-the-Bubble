extends Button
class_name CustomBubbleButton

const BORDER_WIDTH = 2
const CORNER_RADIUS = 10
const CORNER_DETAIL = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var normal_stylebox = create_stylebox(
		Color(0.075, 0.078, 0.188),
		Color(0.353, 0.482, 0.58)
	)
	
	var hover_stylebox = create_stylebox(
		Color(0.11, 0.114, 0.214, 1.0),
		Color(0.37, 0.565, 0.669, 1.0)
	)
	
	var pressed_stylebox = create_stylebox(
		Color(0.044, 0.047, 0.131, 1.0),
		Color(0.234, 0.334, 0.409, 1.0)
	)
	
	set("theme_override_styles/normal", normal_stylebox)
	set("theme_override_styles/hover", hover_stylebox)
	set("theme_override_styles/pressed", pressed_stylebox)

func create_stylebox(bg_color, border_color) -> StyleBoxFlat:
	var normal_stylebox = StyleBoxFlat.new()
	normal_stylebox.bg_color = bg_color
	normal_stylebox.border_color = border_color
	normal_stylebox.set_border_width_all(BORDER_WIDTH)
	normal_stylebox.set_corner_radius_all(CORNER_RADIUS)
	normal_stylebox.corner_detail = CORNER_DETAIL
	return normal_stylebox
