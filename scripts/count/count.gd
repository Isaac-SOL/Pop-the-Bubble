extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@export var parent: Node

const COUNT_ENERVE_FRAMES = preload("uid://cj2858f6qw0aj")
const COUNT_SURPRIS_FRAMES = preload("uid://kve5vfowpgq6")

var rand_range: Vector2 = Vector2(10.0, 20.0)
var rand_timer: Timer

func _ready() -> void:
	rand_timer = Timer.new()
	add_child(rand_timer)
	rand_timer.timeout.connect(count_action)
	rand_timer.start(randf_range(rand_range.x,rand_range.y))
	


func count_action()->void:
	PowerManager.activate_random_power()
	rand_timer.start(randf_range(rand_range.x,rand_range.y))
