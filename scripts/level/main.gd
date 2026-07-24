class_name Main extends Node2D

enum State {
	INTRO,
	CLICK_BUBBLE_START,
	GAMING
}

const BUBBLE = preload("uid://btrnaiw5jker4")
const NUGGET_EXPLOSION = preload("uid://5hna500nh7w")

const PLANETE_BUBBLE_SECHE_USINE = preload("uid://bg3oe0ctr6p6i")
const PLANETE_BUBBLE_MOUILLEE_USINE = preload("uid://dki4bvktbg4tj")
const PLANETE_BULLE_HERBE_USINE = preload("uid://dppwxq54fw3w3")

var state := State.INTRO

@onready var background: Sprite2D = %background
@onready var label_threshold: Label = %LabelThreshold
@onready var player_hand: Hand = $player_hand
@onready var powers_container: VBoxContainer = %powers_container
@onready var count: Node2D = %count
@onready var nugget_parent: Node2D = %NuggetParent

@export var lose_threshold: int = 200
@export var bbl_lvl_value = {0:0, 1:2, 2:12, 3:75, 4: 160}
var ini_spawn_bylvl = [0, 0, 0, 0] #Nombre de bulles initiales

var spawn_rect: Rect2

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.set_main_reference(self)
	label_threshold.text += str(lose_threshold)
	spawn_rect = %SpawnRect.shape.get_rect()
	spawn_rect.position += %SpawnRect.global_position
	update_bubble_count()
	
	%player_hand.visible = false
	%player_hand.can_click = false
	
	await Global.seconds(2.0)
	Global.dialogue_node.set_dialogue("Finally... After such a long time...", 0)
	await Global.dialogue_node.dialogue_passed
	await Global.seconds(0.5)
	Global.dialogue_node.set_dialogue("I, Count Louis von Bubble, have fused all industries of the world into a single, big bubble factory!", 0)
	var big_bubble = Global.main_node.spawn_bubble(%SpawnRect.position, 5, 1)[0]
	big_bubble.speed = 0.0
	await Global.dialogue_node.dialogue_passed
	await Global.seconds(0.5)
	Global.dialogue_node.set_dialogue("INFINITE GROWTH ! Right at my fingertips !", 0)
	await Global.dialogue_node.dialogue_passed
	await Global.seconds(0.5)
	Global.dialogue_node.set_dialogue("I just need a little bit more, and then......", 0)
	
	await Global.dialogue_node.dialogue_passed
	%player_hand.can_click = true
	
	await big_bubble.popped
	%player_hand.visible = true
	await Global.seconds(0.5)
	Global.dialogue_node.set_dialogue("YOU ! Who do you think you are !?", 5, true)
	AudioManager.playAudio_stream_music(&"feel_the_bubble")
	%count.start_doing_actions()
	set_count_phase(0)


func _process(_delta: float) -> void:
	if Input.is_action_pressed("left_click"):
		Global.dialogue_node.pass_dialogue()


func spawn_bubble(pos: Vector2, level: int, qty: int = 1, types: Array = []) -> Array[Bubble]:
	var spawned: Array[Bubble] = []
	for i in range(qty):
		var bubble: Bubble = BUBBLE.instantiate()
		bubble.bubble_level = level
		bubble.bubble_types = types
		%BubblesParent.add_child(bubble)
		bubble.position = pos
		bubble.popped.connect(_on_bubble_popped, ConnectFlags.CONNECT_APPEND_SOURCE_OBJECT)
		bubble.spawn.connect(_on_bubble_spawn, ConnectFlags.CONNECT_APPEND_SOURCE_OBJECT)
		Global.all_bubbles.append(bubble)
		bubble.on_spawn()
		spawned.append(bubble)
	check_lose()
	return spawned

func update_bubble_count()-> void:
	%LabelBubbles.text = "%d bubbles" % Global.all_bubbles.size()
	Global.bubble_per_seconds = 0.
	for b: Bubble in Global.all_bubbles:
		if b.is_factory:
			Global.bubble_per_seconds += b.spawn_rate /100. * 1./b.timer_factory.wait_time 
	%LabelBubblesPerSec.text = "%.2f bps" % Global.bubble_per_seconds
	check_win()

func check_lose()-> void:
	if Global.all_bubbles.size() >= lose_threshold:
		%ui_gameover.show()

func check_win()-> void:
	if state != State.GAMING:
		return
	if Global.all_bubbles.size() <= 0:
		%ui_victory.show()

func set_count_phase(phase: int)-> void:
	match phase:
		0:
			#BubbleManager.phase_powers = [BubbleManager.BUBBLE_FACTORY]
			BubbleManager.phase_powers = [BubbleManager.BUBBLE_INTERNET, BubbleManager.BUBBLE_DIVIDEND, BubbleManager.BUBBLE_SPECULATIVE, BubbleManager.BUBBLE_METAVERSE, BubbleManager.BUBBLE_STONK, BubbleManager.BUBBLE_FACTORY, BubbleManager.BUBBLE_STORM, BubbleManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_NORMAL_FRAMES
			background.texture = PLANETE_BUBBLE_SECHE_USINE
			for lvl in range(3-1):
				for i in range(ini_spawn_bylvl[lvl]):
					BubbleManager.spawn_bubble(Util.rand_in_rectangle(spawn_rect), lvl, 1)
			for i in range(ini_spawn_bylvl[3]):
				BubbleManager.spawn_bubble(Util.rand_in_rectangle(spawn_rect), 3, 1, [BubbleManager.BUBBLE_FACTORY])
		1:
			BubbleManager.phase_powers = [BubbleManager.BUBBLE_FACTORY, BubbleManager.BUBBLE_STORM, BubbleManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_SURPRIS_FRAMES
			BubbleManager.spawn_bubble(Util.rand_in_rectangle(spawn_rect), 3, 3, [BubbleManager.BUBBLE_FACTORY])
		2:
			BubbleManager.phase_powers = [BubbleManager.BUBBLE_FACTORY, BubbleManager.BUBBLE_STORM, BubbleManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_ENERVE_FRAMES
			background.texture = PLANETE_BUBBLE_MOUILLEE_USINE
		3:
			BubbleManager.phase_powers = [BubbleManager.BUBBLE_FACTORY, BubbleManager.BUBBLE_STORM, BubbleManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_SAIYAN_FRAMES
		4:
			BubbleManager.phase_powers = [BubbleManager.BUBBLE_FACTORY, BubbleManager.BUBBLE_STORM, BubbleManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_ENERVE_FRAMES
			background.texture = PLANETE_BULLE_HERBE_USINE
		5:
			BubbleManager.phase_powers = [BubbleManager.BUBBLE_FACTORY, BubbleManager.BUBBLE_STORM, BubbleManager.BUBBLE_GPT]
			count.animated_sprite_2d.sprite_frames = count.COUNT_ENERVE_FRAMES
			
#Instantiate a nugget explosion when a popping a bubble
func add_nugget_explosion(qty: int, spawn_position: Vector2)-> void:
	var nugget_instance : Node2D = NUGGET_EXPLOSION.instantiate()
	nugget_parent.add_child(nugget_instance)
	nugget_instance.spawn(qty,spawn_position,count)

var screenshake_tween: Tween
func shake_vertical(strength: float, duration: float):
	if screenshake_tween != null:
		screenshake_tween.kill()
	screenshake_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	const cam_center := Vector2(640, 360)
	%Camera2D.position = cam_center + Vector2.UP * strength
	screenshake_tween.tween_property(%Camera2D, "position", cam_center, duration)

# -- Signals --

func _on_bubble_popped(is_deleted: bool, bubble: Bubble):
	var i: int = 0
	var lvl: int 
	Global.all_bubbles.erase(bubble)
	if is_deleted:
		bubble.queue_free()
	else:
		add_nugget_explosion(bubble.nugget_value, bubble.global_position)
		while i < bbl_lvl_value[bubble.bubble_level]:
			lvl = randi() % bubble.bubble_level
			i += 1 + bbl_lvl_value[lvl]
			Global.main_node.spawn_bubble(bubble.position, lvl)
		bubble.pop_animation()
		shake_vertical(bubble.bubble_level * bubble.bubble_level * 3, 0.5)
	update_bubble_count()

func _on_bubble_spawn(amount: int, pos: Vector2, level: int, _bubble: Bubble):
	for i in range(amount):
		Global.main_node.spawn_bubble(pos, level)
	update_bubble_count()
