class_name Main extends Node2D

const BUBBLE_NORMAL = preload("uid://btrnaiw5jker4")
const BUBBLE_SPAWNER = preload("uid://cqjldkck6wown")

@onready var area_2d_border: Area2D = $Area2D_border
@onready var label_threshold: Label = %LabelThreshold

@export var spawn_amount: int = 10
@export var spawner_spawn_amount: int = 10
@export var lose_threshold: int = 500

var spawn_rect: Rect2
var all_bubbles: Array[Bubble] = []

func _ready() -> void:
	label_threshold.text += str(lose_threshold)
	spawn_rect = %SpawnRect.shape.get_rect()
	spawn_rect.position += %SpawnRect.global_position
	for i in range(spawn_amount):
		spawn_bubble(Util.rand_in_rectangle(spawn_rect), 0)
	for i in range(spawner_spawn_amount):
		spawn_bubble(Util.rand_in_rectangle(spawn_rect), 3, BUBBLE_SPAWNER)
	update_bubble_count()
	


func spawn_bubble(pos: Vector2, level: int, template: PackedScene = BUBBLE_NORMAL)-> void:
	var bubble: Bubble = template.instantiate()
	bubble.bubble_level = level
	%BubblesParent.add_child(bubble)
	bubble.position = pos
	bubble.popped.connect(_on_bubble_popped, ConnectFlags.CONNECT_APPEND_SOURCE_OBJECT)
	bubble.spawn.connect(_on_bubble_spawn, ConnectFlags.CONNECT_APPEND_SOURCE_OBJECT)
	all_bubbles.append(bubble)
	check_lose()

func update_bubble_count()-> void:
	%LabelBubbles.text = "%d bubbles" % all_bubbles.size()
	Global.bubble_per_seconds = 0
	for b: Bubble in all_bubbles:
		Global.bubble_per_seconds += b.bubble_level
	%LabelBubblesPerSec.text = "%d bps" % Global.bubble_per_seconds
	check_win()

func check_lose()-> void:
	if all_bubbles.size() >= lose_threshold:
		%ui_gameover.show()

func check_win()-> void:
	if all_bubbles.size() <= 0:
		%ui_victory.show()

# -- Signals --

func _on_bubble_popped(is_deleted: bool, bubble: Bubble):
	bubble.queue_free()
	all_bubbles.erase(bubble)
	if !is_deleted:
		for i in range(bubble.spawn_on_pop):
			spawn_bubble(Util.rand_in_rectangle(spawn_rect), bubble.bubble_level-1)
	update_bubble_count()

func _on_bubble_spawn(amount: int, _bubble: Bubble):
	for i in range(amount):
		spawn_bubble(Util.rand_in_rectangle(spawn_rect), _bubble.bubble_level-1)
	update_bubble_count()
