extends Bubble
class_name BubbleSpawner
@export var taux_de_spawn: int = 72 #pourcentage

func _ready() -> void:
	super()
	Global.factory_bubble_count += 1
	shader_material.set_shader_parameter("wobble_strenght", 0.05)
	
func bubble_popped()-> void:
	Global.factory_bubble_count -= 1
	super()
	
func bubble_deleted()-> void:
	Global.factory_bubble_count -= 1
	super()

func _on_timer_timeout() -> void:
	if randi() % 101 > taux_de_spawn:
		spawn.emit(1, position, 0)
