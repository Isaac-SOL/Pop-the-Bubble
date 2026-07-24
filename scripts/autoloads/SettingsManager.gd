extends Node

const CURSOR = preload("uid://dg3pat0tp4e7j")

var screenSize : Vector2i


func apply_subviewport_scale() -> void:
	var screen_size := DisplayServer.screen_get_size()
	get_viewport().size = screen_size
	

func apply_mouse_scale() -> void:
	if screenSize != DisplayServer.window_get_size():
		screenSize = DisplayServer.window_get_size()
		var image: Image = CURSOR.get_image()

		var scale_factor : float = minf((float(get_viewport().size.x) / get_viewport().get_visible_rect().size.x), (float(get_viewport().size.y) / get_viewport().get_visible_rect().size.y))

		var new_size : Vector2 = image.get_size() * scale_factor * 0.2
		@warning_ignore("narrowing_conversion")
		image.resize(new_size.x, new_size.y, Image.INTERPOLATE_NEAREST)

		var new_texture : Texture2D = ImageTexture.create_from_image(image)
		
		Input.set_custom_mouse_cursor(new_texture, Input.CURSOR_ARROW,Vector2(new_size.x/2.0, new_size.y/2.0))
