extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var rand_timer: Timer

func _ready() -> void:
	rand_timer = Timer.new()
	add_child(rand_timer)
	rand_timer.timeout.connect(count_action)
	rand_timer.start(randf_range(1.0,2.0))
	
	

func count_action()->void:
	PowerManager.activate_random_power()
	rand_timer.start(randf_range(10.0,20.0))
