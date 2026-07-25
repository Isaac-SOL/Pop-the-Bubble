extends Area2D
class_name Bubble


signal popped(is_deleted : bool)
@warning_ignore("unused_signal")
signal spawn(amount: int, pos: Vector2, level: int)

@onready var audio_stream_player_2d_bubble_up: AudioStreamPlayer2D = %AudioBubbleUp
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D


@export var bubble_level: int = 0
@export var bubble_color: Color = Color.WHITE
@export var speed_mult_at_start = 6.0

const DEFAULT_SPAWN_RATE : int = 25
const DEFAULT_FACTORY_MAX_RANGE_TIMER : float = 5.0

var shader_material : ShaderMaterial
var speed : float
var velocity: Vector2
var bubble_types: Array
var speed_start_mult: float = 1.0
var stonk_count: int = 0

var is_stonk: bool = false
var is_speculative: bool = false
var is_dividend: bool = false
var is_factory: bool = false
var is_internet: bool = false
var is_gpt: bool = false
var is_storm: bool = false
var is_metaverse: bool = false

var timer_factory: Timer
var timer_metaverse: Timer
var timer_dividend: Timer

var factory_max_range_timer : float = DEFAULT_FACTORY_MAX_RANGE_TIMER
var spawn_rate: int = DEFAULT_SPAWN_RATE
var nugget_value: int
var dead: bool = false
var spawn_factories: bool = false

func _ready() -> void:
	#sprite_2d.material = sprite_2d.material.duplicate()
	shader_material = sprite_2d.material
	area_entered.connect(_on_area_2d_bubble_area_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(bubble_deleted)
	scale = Vector2(1.0+bubble_level/1.5, 1.0+bubble_level/1.5)
	nugget_value = (bubble_level+1)*3
	match bubble_level:
		0:
			set_color(Color.SKY_BLUE)
			set_collision_layer_value(3, false)
			set_collision_mask_value(3, false)
		1:
			set_color(Color.CADET_BLUE)
		2:
			set_color(Color.DARK_BLUE)
		3:
			set_color(Color.PURPLE)
		4:
			set_color(Color.REBECCA_PURPLE)
		5:
			set_color(Color.WHITE)
			scale = Vector2.ZERO
			var scale_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			scale_tween.tween_property(self, "scale", Vector2.ONE * 7, 2.0)
	
	velocity = Util.rand_on_circle()
	speed = randf_range(100.0,200.0) / (1.0+bubble_level/1.5)
	
	if bubble_types.size() > 0:
		for type in bubble_types:
			match type:
				BubbleManager.BUBBLE_DIVIDEND:
					set_bubble_dividend()
				BubbleManager.BUBBLE_FACTORY:
					set_bubble_factory()
				BubbleManager.BUBBLE_SPECULATIVE:
					set_bubble_speculative()
				BubbleManager.BUBBLE_STONK:
					set_bubble_stonk()
				BubbleManager.BUBBLE_GPT:
					set_bubble_gpt()
				BubbleManager.BUBBLE_METAVERSE:
					set_bubble_metaverse()
				BubbleManager.BUBBLE_INTERNET:
					set_bubble_internet()
	
	
func _physics_process(delta: float) -> void:
	if dead:
		return
	position += velocity * speed * speed_start_mult * BubbleManager.bubble_speed_mult * delta
	if is_speculative:
		scale += Vector2(delta,delta)
	
	
func _on_area_2d_bubble_area_entered(area: Area2D) -> void:
	if dead:
		return
	if area is Bubble and not area.dead:
		AudioManager.play_bubble_collision()
		var opposite_vector : Vector2 = (global_position - area.global_position).normalized()
		velocity = velocity.bounce(opposite_vector)
	elif area.get_parent() is Hand:
		AudioManager.play_bubble_collision()
		var opposite_vector : Vector2 = (global_position - area.global_position).normalized()
		velocity = opposite_vector * 5.0
		
func set_bubble_stonk(stonk_value: int = 3)-> void:
	if !is_stonk:
		is_stonk = true
		Global.stonk_bubble_count += 1
		stonk_count = stonk_value
		set_color(Color.DARK_GREEN)
		
func set_bubble_speculative()-> void:
	is_speculative = true
	Global.speculative_bubble_count += 1
	set_color(Color.GREEN)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
		
func set_bubble_dividend()-> void:
	is_dividend = true
	Global.dividend_bubble_count += 1
	spawn_rate = 0
	set_color(Color.ORANGE_RED)
	shader_material.set_shader_parameter("wobble_strength", 0.05)
	timer_dividend = Timer.new()
	timer_dividend.one_shot = true
	add_child(timer_dividend)
	timer_dividend.timeout.connect(create_bubble.bind(timer_dividend, Vector2(7.0,7.0), true, 0, 1, [BubbleManager.BUBBLE_DIVIDEND]))
	timer_dividend.start(7.0)
	
func set_bubble_factory()-> void:
	is_factory = true
	Global.factory_bubble_count += 1
	spawn_rate = 50
	set_color(Color.HOT_PINK)
	shader_material.set_shader_parameter("wobble_strength", 0.05)
	timer_factory = Timer.new()
	timer_factory.one_shot = true
	add_child(timer_factory)
	timer_factory.timeout.connect(create_bubble.bind(timer_factory, Vector2(1.0,factory_max_range_timer), true, 1, 2))
	timer_factory.start(1.0)
	
func set_bubble_internet(activate: bool = true)-> void:
	if activate:
		is_internet = true
		Global.internet_bubble_count += 1
		set_color(Color.GRAY)
		shader_material.set_shader_parameter("wobble_strength", 0.05)
		for bubble : Bubble in Global.all_bubbles:
			if bubble.is_factory:
				bubble.spawn_rate = 0
				bubble.factory_max_range_timer = 1.5
	else:
		for bubble : Bubble in Global.all_bubbles:
			if bubble.is_factory:
				bubble.pawn_rate = bubble.DEFAULT_SPAWN_RATE
				bubble.factory_max_range_timer = bubble.DEFAULT_FACTORY_MAX_RANGE_TIMER
		
	
func set_bubble_gpt(activate: bool = true)-> void:
	if activate:
		is_gpt = true
		Global.gpt_bubble_count += 1
		set_color(Color.RED)
		shader_material.set_shader_parameter("wobble_strength", 0.05)
		Global.main_node.player_hand.area.set_collision_layer_value(5, true)
	else:
		Global.main_node.player_hand.area.set_collision_layer_value(5, false)
	
func set_bubble_metaverse()-> void:
	is_metaverse = true
	Global.metaverse_bubble_count += 1
	spawn_rate = 75
	set_color(Color.ORANGE)
	shader_material.set_shader_parameter("wobble_strength", 0.05)
	timer_metaverse = Timer.new()
	timer_metaverse.one_shot = true
	add_child(timer_metaverse)
	timer_metaverse.timeout.connect(create_bubble.bind(timer_metaverse, Vector2(7.0,9.0), false, 4, 1))
	timer_metaverse.start(3.0)
		
	
func set_bubble_storm(activate: bool = true)-> void:
	if activate:
		is_storm = true
		Global.storm_bubble_count += 1
		set_color(Color.YELLOW)
		shader_material.set_shader_parameter("wobble_strength", 0.05)
		BubbleManager.bubble_speed_mult = 3.0
	else:
		BubbleManager.bubble_speed_mult = 1.0
	


func create_bubble(timer: Timer, timer_range : Vector2, is_self_pos : bool, level: int, qty: int = 1, types: Array = [])-> void:
	#25% luck to spawn bubble with spawn_rate = 75
	if randi() % 101 > spawn_rate:
		var pos : Vector2
		if is_self_pos:
			pos = Vector2(position.x+randf_range(-1.0,1.0), position.y+randf_range(-1.0,1.0))
		else:
			pos = Util.rand_in_rectangle(Global.main_node.spawn_rect)
		Global.main_node.spawn_bubble(pos, level, qty, types)
	timer.start(randf_range(timer_range.x, timer_range.y))

	

func bubble_popped()-> void:
	if dead:
		return
	if stonk_count > 0:
		stonk_count-=1
		scale*=1.2
		audio_stream_player_2d_bubble_up.play()
		audio_stream_player_2d_bubble_up.pitch_scale += 0.2
	else:
		remove_bubble()
		AudioManager.playAudio_stream_sfx(&"bubble_pop")			
		popped.emit(false)
	
func bubble_deleted()-> void:
	if dead:
		return
	remove_bubble()
	
func remove_bubble()-> void:
	if is_stonk:
		Global.stonk_bubble_count -= 1
	if is_speculative:
		Global.speculative_bubble_count -= 1
	if is_dividend:
		Global.dividend_bubble_count -= 1
	if is_factory:
		Global.factory_bubble_count -=1
	if is_gpt:
		Global.gpt_bubble_count -=1
		if Global.gpt_bubble_count <= 0:
			set_bubble_gpt(false)
	if is_storm:
		Global.storm_bubble_count -=1
		if Global.storm_bubble_count <= 0:
			set_bubble_storm(false)
	if is_metaverse:
		Global.metaverse_bubble_count -=1
	if is_internet:
		Global.internet_bubble_count -=1
		if Global.internet_bubble_count <= 0:
			set_bubble_internet(false)
	
func set_color(color: Color):
	bubble_color = color
	shader_material.set_shader_parameter("bubble_color", bubble_color)
	shader_material.set_shader_parameter("rim_color", bubble_color+Color(0.1,0.1,0.1,0.0))
	

func on_spawn():
	speed_start_mult = speed_mult_at_start
	var speed_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	speed_tween.tween_property(self, "speed_start_mult", 1.0, randf_range(1.6, 2.3))

func pop_animation():
	dead = true
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	sprite_2d.hide()
	%Splash.show()
	%Splash.scale = Vector2.ONE * 0.365
	var splash_tween := create_tween().set_trans(Tween.TRANS_QUAD)
	splash_tween.tween_property(%Splash, "scale", Vector2.ONE * 0.4, 0.16).set_ease(Tween.EASE_OUT)
	splash_tween.tween_property(%Splash, "scale", Vector2.ONE * 0.365, 0.16).set_ease(Tween.EASE_IN)
	splash_tween.tween_callback(queue_free)
