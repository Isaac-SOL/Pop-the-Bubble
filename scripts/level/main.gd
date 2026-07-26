class_name Main extends Node2D

enum State {
	INTRO,
	CLICK_BUBBLE_START,
	GAMING
}

const BUBBLE = preload("uid://btrnaiw5jker4")
const BUBBLE_POPCLOSE = preload("uid://bv6qy7md01hw4")
const NUGGET_EXPLOSION = preload("uid://5hna500nh7w")


const PLANETE_BUBBLE_SECHE_USINE = preload("uid://bg3oe0ctr6p6i")
const PLANETE_BUBBLE_MOUILLEE_USINE = preload("uid://dki4bvktbg4tj")
const PLANETE_BULLE_HERBE_USINE = preload("uid://dppwxq54fw3w3")

var state := State.INTRO

@onready var background_0: Sprite2D = %background_0
@onready var background_1: Sprite2D = %background_1
@onready var background_2: Sprite2D = %background_2
@onready var player_hand: Hand = $player_hand
#@onready var powers_container: VBoxContainer = %powers_container
@onready var count: Count = %count
@onready var nugget_parent: Node2D = %NuggetParent

@export var lose_threshold: int = 200
var ini_spawn_bylvl = [0, 0, 0, 0] #Nombre de bulles initiales

var spawn_rect: Rect2

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.set_main_reference(self)
	spawn_rect = %SpawnRect.shape.get_rect()
	spawn_rect.position += %SpawnRect.global_position
	update_bubble_count()
	%BubbleBar.max_value = lose_threshold
	
	
	%player_hand.visible = false
	%player_hand.can_click = false
	
	await Global.seconds(2.0)
	Global.dialogue_node.set_dialogue("Finally... After such a long time...", 0)
	await Global.dialogue_node.dialogue_passed
	await Global.seconds(0.5)
	Global.dialogue_node.set_dialogue("I, Count Louis von Bubble, have fused all industries of the world into a single, big bubble factory!", 0)
	var big_bubble = spawn_bubble(%SpawnRect.position, 3, 1)[0]
	big_bubble.speed = 0.0
	big_bubble.spawn_factories = true
	await Global.dialogue_node.dialogue_passed
	await Global.seconds(0.5)
	Global.dialogue_node.set_dialogue("INFINITE GROWTH! Right at my fingertips!", 0)
	await Global.dialogue_node.dialogue_passed
	await Global.seconds(0.5)
	Global.dialogue_node.set_dialogue("I just need a little bit more, and then......", 0)
	
	await Global.dialogue_node.dialogue_passed
	%player_hand.can_click = true
	state = State.CLICK_BUBBLE_START
	
	await big_bubble.popped
	%player_hand.visible = true
	set_count_phase(1)
	state = State.GAMING
	%count.start_doing_actions()

func auto_dialogue_p1():
	spawn_bubble(%SpawnRect.position, 4, 1, [], BUBBLE_POPCLOSE)[0].speed = 250
	await Global.seconds(4)
	Global.dialogue_node.set_dialogue("Hmph. An anti-bubblist stuck in the past, I see.")
	await Global.seconds(15)
	Global.dialogue_node.set_dialogue("Your popping is meaningless. You cannot hurt me in a way that matters.")
	count.animated_sprite_2d.play("mepris")
	await Global.seconds(5)
	count.animated_sprite_2d.play("normal")
	await Global.seconds(9)
	Global.dialogue_node.set_dialogue("You think you're being smart? [color=red]If you destroy my factories willy-nilly, you're gonna destabilize everything![/color]")
	await Global.seconds(5)
	Global.dialogue_node.set_dialogue("Also, you can't [color=red]keep popping my bubbles without lifting your finger.[/color] It doesn't work!")
	await Global.seconds(6)
	Global.dialogue_node.set_dialogue("Let's see you try to deal with this!", 5)
	var popclose := spawn_bubble(%SpawnRect.position, 1, 1, [], BUBBLE_POPCLOSE)[0]
	popclose.speed = 250
	#await popclose.popped
	await Global.seconds(6)
	Global.dialogue_node.set_dialogue("And another one!", 5)
	spawn_bubble(%SpawnRect.position, 1, 1, [], BUBBLE_POPCLOSE)[0].speed = 250
	await Global.seconds(10)
	Global.dialogue_node.set_dialogue("Is that all you are? A destabilizer? Tell me, have you ever *built* anything?")
	#spawn_bubble(%SpawnRect.position, 1, 1, [], BUBBLE_POPCLOSE)[0].speed = 250
	await Global.seconds(10)
	Global.dialogue_node.set_dialogue("I built all this with my grand intellect! My growth-focused mindset!")
	#spawn_bubble(%SpawnRect.position, 1, 1, [], BUBBLE_POPCLOSE)[0].speed = 250
	await Global.seconds(10)
	Global.dialogue_node.set_dialogue("I started with pretty much nothing! Nothing but my parents' bubble mine in the south!")
	#spawn_bubble(%SpawnRect.position, 1, 1, [], BUBBLE_POPCLOSE)[0].speed = 250
	await Global.seconds(10)
	Global.dialogue_node.set_dialogue("I'm a self-made man!", 3)
	spawn_bubble(%SpawnRect.position, 1, 2, [], BUBBLE_POPCLOSE)[0].speed = 250
	Global.can_advance_phase = true

func auto_dialogue_p2():
	Global.dialogue_node.set_dialogue("OUCH!")
	await Global.seconds(5)
	count.animated_sprite_2d.play("vener")
	Global.dialogue_node.set_dialogue("You are still not done yet? What have I done to you to deserve this?")
	await Global.seconds(12)
	Global.dialogue_node.set_dialogue("And what is it? A fanfare? Does that make you the triangle player?")
	await Global.seconds(18)
	Global.dialogue_node.set_dialogue("Go do something else, I don't know, go take a trip in your private jet?")
	await Global.seconds(10)
	Global.dialogue_node.set_dialogue("What do you mean you not have one, everyone has!")
	await Global.seconds(10)
	Global.dialogue_node.set_dialogue("Anyway, shoo, shoo!")
	await Global.seconds(10)
	count.animated_sprite_2d.play("mepris")
	Global.dialogue_node.set_dialogue("Why don't you just go and get a job, huh!? It's easy, just go across the street over there!")
	await Global.seconds(10)
	count.animated_sprite_2d.play("normal")
	Global.dialogue_node.set_dialogue("For God's sake, just let the rich be rich...")
	await Global.seconds(10)
	Global.dialogue_node.set_dialogue("Counting can actually help you feel better. It’s as simple as Count, Breathe, Relax!")
	
	Global.can_advance_phase = true
func auto_dialogue_p3():
	Global.dialogue_node.set_dialogue("...")
	await Global.seconds(5)
	Global.dialogue_node.set_dialogue("Now you've done it.")
	await Global.seconds(5)
	Global.dialogue_node.set_dialogue("I'm going to take this seriously.")
	await Global.seconds(5)
	Global.dialogue_node.set_dialogue("[color=red]Goodbye.[/color]")
	await Global.seconds(5)
	count.animated_sprite_2d.play("saiyan")
	%count.shake()
	shake_vertical(200, 2)
	spawn_bubble(%SpawnRect.position, 2, 3, [], BUBBLE_POPCLOSE)[0].speed = 250
	await Global.seconds(10)
	Global.dialogue_node.set_dialogue("THE LIFE WORK OF A CENTURY!!!")
	await Global.seconds(10)
	Global.dialogue_node.set_dialogue("ALL GOING AWAY BECAUSE OF A MEASLY PEASANT!!!")
	await Global.seconds(10)
	Global.dialogue_node.set_dialogue("[color=red]I WILL END YOU RIGHT NOW!!![/color]")
	Global.can_advance_phase = true
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		Global.dialogue_node.pass_dialogue()
	if Input.is_action_just_pressed("debug_spawn_popclose"):
		spawn_bubble(%SpawnRect.position, 3, 1, [], BUBBLE_POPCLOSE)


func spawn_bubble(pos: Vector2, level: int, qty: int = 1, types: Array = [], template: PackedScene = BUBBLE) -> Array[Bubble]:
	var spawned: Array[Bubble] = []
	for i in range(qty):
		var bubble: Bubble = template.instantiate()
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
	Global.bubble_per_seconds = 0.
	for b: Bubble in Global.all_bubbles:
		if b.is_factory:
			Global.bubble_per_seconds += b.spawn_rate /100. * 1./b.timer_factory.wait_time 
	%LabelBubblesPerSec.text = "%.2f bps" % Global.bubble_per_seconds
	check_win()

func check_lose()-> void:
	if Global.all_bubbles.size() >= lose_threshold:
		%ui_gameover.show()
		get_tree().paused = true

func check_win()-> void:
	if state != State.GAMING or not Global.can_advance_phase:
		return
	if BubbleManager.special_bubble_count == 0 and Global.factory_bubble_count == 0:
		if (Global.count_phase == 3 and Global.all_bubbles.size() == 0) or (Global.count_phase < 3 and Global.all_bubbles.size() <= (%BubbleBar.max_value * 0.1)): 
			Global.count_phase += 1
			set_count_phase(Global.count_phase)

func set_count_phase(phase: int)-> void:
	Global.count_phase = phase
	AudioManager.set_music_phase(phase)
	Global.can_advance_phase = false
	match phase:
		1:
			#BubbleManager.phase_powers = []
			BubbleManager.phase_powers = []
			count.animated_sprite_2d.play("surpris")
			await Global.seconds(1)
			count.animated_sprite_2d.play("vener")
			Global.dialogue_node.set_dialogue("YOU! Who do you think you are!?", 3, true)
			%count.shake()
			await Global.dialogue_node.dialogue_cleared
			await Global.seconds(1)
			count.animated_sprite_2d.play("normal")
			auto_dialogue_p1()
			
		2:
			BubbleManager.phase_powers = [BubbleManager.BUBBLE_SHIELDING, BubbleManager.BUBBLE_SPECULATIVE, BubbleManager.BUBBLE_STONK, BubbleManager.BUBBLE_GPT]
			var tween = create_tween().set_trans(Tween.TRANS_QUAD).tween_property(background_0,"modulate",Color.TRANSPARENT,4)
			count.animated_sprite_2d.play("surpris")
			%count.shake()
			auto_dialogue_p2()
		3:
			BubbleManager.phase_powers = [BubbleManager.BUBBLE_SHIELDING, BubbleManager.BUBBLE_SPIKE, BubbleManager.BUBBLE_CRASH, BubbleManager.BUBBLE_INTERNET, BubbleManager.BUBBLE_DIVIDEND, BubbleManager.BUBBLE_SPECULATIVE, BubbleManager.BUBBLE_STONK, BubbleManager.BUBBLE_GPT]
			var tween = create_tween().set_trans(Tween.TRANS_QUAD).tween_property(background_1,"modulate",Color.TRANSPARENT,4)
			%count.shake()
			auto_dialogue_p3()
		4:
			BubbleManager.phase_powers = []
			#background.texture = PLANETE_BULLE_HERBE_NO_USINE
			#count.animated_sprite_2d.play("victoire")
			%ui_victory.show()
			get_tree().paused = true

			
#Instantiate a nugget explosion when a popping a bubble
func add_nugget_explosion(qty: int, spawn_position: Vector2)-> void:
	var nugget_instance : Node2D = NUGGET_EXPLOSION.instantiate()
	nugget_parent.add_child(nugget_instance)
	nugget_instance.spawn(qty,spawn_position,count)

var screenshake_tween: Tween
var screenshake_priority: float = 0.0
func shake_vertical(strength: float, duration: float):
	if screenshake_tween != null:
		if screenshake_tween.is_running() and strength < screenshake_priority:
			return
		screenshake_tween.kill()
	screenshake_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	const cam_center := Vector2(640, 360)
	%Camera2D.position = cam_center + Vector2.UP * strength
	screenshake_tween.tween_property(%Camera2D, "position", cam_center, duration)
	screenshake_priority = strength

# -- Signals --

func _on_bubble_popped(is_deleted: bool, bubble: Bubble):
	Global.all_bubbles.erase(bubble)
	if is_deleted:
		bubble.queue_free()
	else:
		#add_nugget_explosion(bubble.nugget_value, bubble.global_position)
		spawn_bubble(bubble.position, 1 if bubble.bubble_level == 3 else 0, bubble.bubble_pop_spawn_qty)
		bubble.pop_animation()
		shake_vertical(bubble.bubble_level * bubble.bubble_level * 3, 0.5)
	update_bubble_count()

func _on_bubble_spawn(amount: int, pos: Vector2, level: int, _bubble: Bubble):
	for i in range(amount):
		Global.main_node.spawn_bubble(pos, level)
	update_bubble_count()


func _on_dialogue_bleep() -> void:
	%count.voice_bleep()
