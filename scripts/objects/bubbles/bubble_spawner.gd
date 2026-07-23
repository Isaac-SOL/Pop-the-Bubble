extends Bubble
class_name BubbleSpawner
@export var taux_de_spawn: int = 72 #pourcentage
@onready var timer: Timer = $Timer

func _ready() -> void:
	super()
	shader_material.set_shader_parameter("wobble_strenght", 0.05)

func _on_timer_timeout() -> void:
	if randi() % 101 > taux_de_spawn:
		spawn.emit(1, position, 0)
	else:
		timer.wait_time += randfn(-.01, .01)
