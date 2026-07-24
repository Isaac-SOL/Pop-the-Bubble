class_name Main extends Node2D

const BUBBLE_NORMAL = preload("uid://btrnaiw5jker4")
const BUBBLE_SPAWNER = preload("uid://cqjldkck6wown")
const NUGGET_EXPLOSION = preload("uid://5hna500nh7w")

const PLANETE_BUBBLE_SECHE_USINE = preload("uid://bg3oe0ctr6p6i")
const PLANETE_BUBBLE_MOUILLEE_USINE = preload("uid://dki4bvktbg4tj")
const PLANETE_BULLE_HERBE_USINE = preload("uid://dppwxq54fw3w3")


@onready var background: Sprite2D = %background
@onready var label_threshold: Label = %LabelThreshold
@onready var player_hand: Area2D = $player_hand
@onready var powers_container: VBoxContainer = %powers_container
@onready var count: Node2D = %count
@onready var nugget_parent: Node2D = %NuggetParent

@export var lose_threshold: int = 200
@export var bbl_lvl_value = {0:0, 1:2, 2:12, 3:75, 4: 160}

var spawn_rect: Rect2

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.set_main_reference(self)
	AudioManager.playAudio_stream_music(&"feel_the_bubble")
	label_threshold.text += str(lose_threshold)
	spawn_rect = %SpawnRect.shape.get_rect()
	spawn_rect.position += %SpawnRect.global_position
	set_count_phase(0)
	update_bubble_count()
	


func spawn_bubble(pos: Vector2, level: int, qty: int = 1, template: PackedScene = BUBBLE_NORMAL)-> void:
	for i in range(qty):
		var bubble: Bubble = template.instantiate()
		bubble.bubble_level = level
		%BubblesParent.add_child(bubble)
		bubble.position = pos
		bubble.popped.connect(_on_bubble_popped, ConnectFlags.CONNECT_APPEND_SOURCE_OBJECT)
		bubble.spawn.connect(_on_bubble_spawn, ConnectFlags.CONNECT_APPEND_SOURCE_OBJECT)
		Global.all_bubbles.append(bubble)
		bubble.on_spawn()
		check_lose()

func update_bubble_count()-> void:
	%LabelBubbles.text = "%d bubbles" % Global.all_bubbles.size()
	Global.bubble_per_seconds = 0
	for b: Bubble in Global.all_bubbles:
		Global.bubble_per_seconds += b.bubble_level
	%LabelBubblesPerSec.text = "%d bps" % Global.bubble_per_seconds
	check_win()

func check_lose()-> void:
	if Global.all_bubbles.size() >= lose_threshold:
		%ui_gameover.show()

func check_win()-> void:
	if Global.all_bubbles.size() <= 0:
		%ui_victory.show()

func set_count_phase(phase: int)-> void:
	match phase:
		0:
			PowerManager.phase_powers = []
			count.animated_sprite_2d.sprite_frames = count.COUNT_SURPRIS_FRAMES
			background.texture = PLANETE_BUBBLE_SECHE_USINE
			spawn_bubble(Util.rand_in_rectangle(spawn_rect), 0, 0)
			spawn_bubble(Util.rand_in_rectangle(spawn_rect), 1, 0)
			spawn_bubble(Util.rand_in_rectangle(spawn_rect), 2, 0)
			spawn_bubble(Util.rand_in_rectangle(spawn_rect), 3, 1, BUBBLE_SPAWNER)
		1:
			PowerManager.phase_powers = [PowerManager.BUBBLE_FACTORY, PowerManager.BUBBLE_STORM, PowerManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_ENERVE_FRAMES
			spawn_bubble(Util.rand_in_rectangle(spawn_rect), 3, 3, BUBBLE_SPAWNER)
		2:
			PowerManager.phase_powers = [PowerManager.BUBBLE_FACTORY, PowerManager.BUBBLE_STORM, PowerManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_ENERVE_FRAMES
			background.texture = PLANETE_BUBBLE_MOUILLEE_USINE
		3:
			PowerManager.phase_powers = [PowerManager.BUBBLE_FACTORY, PowerManager.BUBBLE_STORM, PowerManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_ENERVE_FRAMES
		4:
			PowerManager.phase_powers = [PowerManager.BUBBLE_FACTORY, PowerManager.BUBBLE_STORM, PowerManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_ENERVE_FRAMES
			background.texture = PLANETE_BULLE_HERBE_USINE
		5:
			PowerManager.phase_powers = [PowerManager.BUBBLE_FACTORY, PowerManager.BUBBLE_STORM, PowerManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_ENERVE_FRAMES
			
#Instantiate a nugget explosion when a popping a bubble
func add_nugget_explosion(qty: int, spawn_position: Vector2)-> void:
	var nugget_instance : Node2D = NUGGET_EXPLOSION.instantiate()
	nugget_parent.add_child(nugget_instance)
	nugget_instance.spawn(qty,spawn_position,count)


# -- Signals --

func _on_bubble_popped(is_deleted: bool, bubble: Bubble):
	var i: int = 0
	var lvl: int 
	bubble.queue_free()
	Global.all_bubbles.erase(bubble)
	if !is_deleted:
		add_nugget_explosion(bubble.nugget_value, bubble.global_position)
		while i < bbl_lvl_value[bubble.bubble_level]:
			lvl = randi() % bubble.bubble_level
			i += 1 + bbl_lvl_value[lvl]
			spawn_bubble(bubble.position, lvl)
	update_bubble_count()

func _on_bubble_spawn(amount: int, pos: Vector2, level: int, _bubble: Bubble):
	for i in range(amount):
		spawn_bubble(pos, level)
	update_bubble_count()
