class_name Main extends Node2D

const BUBBLE = preload("uid://2qworjpbh3wp")
const BUBBLE_SPAWNER = preload("uid://co0ojtanaglxp")

@export var spawn_amount: int = 10
@export var spawner_spawn_amount: int = 10

var spawn_rect: Rect2
var all_bubbles: Array[Bubble] = []

func _ready() -> void:
	spawn_rect = %SpawnRect.shape.get_rect()
	spawn_rect.position += %SpawnRect.global_position
	for i in range(spawn_amount):
		spawn_bubble(Util.rand_in_rectangle(spawn_rect))
	for i in range(spawner_spawn_amount):
		spawn_bubble(Util.rand_in_rectangle(spawn_rect), BUBBLE_SPAWNER)
	update_bubble_count()

func spawn_bubble(pos: Vector2, template: PackedScene = BUBBLE):
	var bubble: Bubble = template.instantiate()
	%BubblesParent.add_child(bubble)
	bubble.position = pos
	bubble.clicked.connect(_on_bubble_clicked, ConnectFlags.CONNECT_APPEND_SOURCE_OBJECT)
	bubble.spawn.connect(_on_bubble_spawn, ConnectFlags.CONNECT_APPEND_SOURCE_OBJECT)
	all_bubbles.append(bubble)

func update_bubble_count():
	%LabelBubbles.text = "%d bubbles" % all_bubbles.size()
	var total_per_sec: int = 0
	for b: Bubble in all_bubbles:
		total_per_sec += b.bubbles_per_second()
	%LabelBubblesPerSec.text = "%d bps" % total_per_sec

# -- Signals --

func _on_bubble_clicked(bubble: Bubble):
	bubble.queue_free()
	all_bubbles.erase(bubble)
	for i in range(bubble.spawn_on_pop):
		spawn_bubble(Util.rand_in_rectangle(spawn_rect))
	update_bubble_count()

func _on_bubble_spawn(amount: int, _bubble: Bubble):
	for i in range(amount):
		spawn_bubble(Util.rand_in_rectangle(spawn_rect))
	update_bubble_count()
