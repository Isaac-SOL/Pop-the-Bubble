class_name Main extends Node2D

const BUBBLE = preload("uid://2qworjpbh3wp")

@export var spawn_amount: int = 10

var spawn_rect: Rect2
var all_bubbles: Array[Bubble] = []

func _ready() -> void:
	spawn_rect = %SpawnRect.shape.get_rect()
	spawn_rect.position += %SpawnRect.global_position
	for i in range(spawn_amount):
		var pos := Util.rand_in_rectangle(spawn_rect)
		spawn_bubble(pos)
	update_bubble_count()

func spawn_bubble(pos: Vector2):
	var bubble: Bubble = BUBBLE.instantiate()
	%BubblesParent.add_child(bubble)
	bubble.position = pos
	bubble.clicked.connect(_on_bubble_clicked, ConnectFlags.CONNECT_APPEND_SOURCE_OBJECT)
	all_bubbles.append(bubble)

func update_bubble_count():
	%LabelBubbles.text = "%d bubbles" % all_bubbles.size()

func _on_bubble_clicked(bubble: Bubble):
	print("clicked %s" % bubble.name)
	bubble.queue_free()
	all_bubbles.erase(bubble)
	update_bubble_count()
