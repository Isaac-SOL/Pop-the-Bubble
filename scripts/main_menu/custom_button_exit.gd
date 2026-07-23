extends CustomBubbleButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	var normal_stylebox:StyleBoxFlat = get("theme_override_styles/normal")
	normal_stylebox.bg_color = Color(0.241, 0.025, 0.155, 1.0)#Color(0.075, 0.078, 0.188)
	var hover_stylebox:StyleBoxFlat = get("theme_override_styles/hover")
	hover_stylebox.bg_color = Color(0.276, 0.079, 0.233, 1.0)
	var pressed_stylebox:StyleBoxFlat = get("theme_override_styles/pressed")
	pressed_stylebox.bg_color = Color(0.205, 0.011, 0.116, 1.0)
