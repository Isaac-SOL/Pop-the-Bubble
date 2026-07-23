extends Bubble
class_name BubbleSpawner

func _ready() -> void:
	super()
	shader_material.set_shader_parameter("wobble_strenght", 0.05)

func _on_timer_timeout() -> void:
	spawn.emit(1)
