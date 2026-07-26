extends Area2D
class_name Bubble

const BUBBLE_NORMAL = preload("uid://d0f32gphcjf01")
const BUBBLE_SPIKE = preload("uid://c7sxcqauptyhh")

signal popped(is_deleted : bool)
@warning_ignore("unused_signal")
signal spawn(amount: int, pos: Vector2, level: int)

@onready var audio_stream_player_2d_bubble_up: AudioStreamPlayer2D = %AudioBubbleUp
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D
@onready var label_pop_spawn_qty: Label = %Label_pop_spawn_qty
@onready var sprite_2d_explosion_radius: Sprite2D = %Sprite2D_explosion_radius


@export var bubble_level: int = 0
@export var bubble_color: Color = Color.WHITE
@export var speed_mult_at_start = 6.0

const DEFAULT_SPAWN_RATE : int = 25
const DEFAULT_FACTORY_MAX_RANGE_TIMER : float = 5.0

var shader_material : ShaderMaterial
var speed : float
var velocity: Vector2
var bubble_types: Array
var bubble_pop_spawn_qty: int = 0
var speed_start_mult: float = 1.0
var stonk_count: int = 0
var shielded_bubble : Bubble
var explosion_radius : float = 300.0

var is_stonk: bool = false
var is_speculative: bool = false
var is_dividend: bool = false
var is_factory: bool = false
var is_internet: bool = false
var is_gpt: bool = false
var is_storm: bool = false
var is_metaverse: bool = false
var is_spike_children: bool = false
var is_spike: bool = false
var is_shielding: bool = false
var is_shielded: bool = false
var is_crash: bool = false

var timer_factory: Timer
var timer_metaverse: Timer
var timer_dividend: Timer
var timer_speculative: Timer

var factory_max_range_timer : float = DEFAULT_FACTORY_MAX_RANGE_TIMER
var spawn_rate: int = DEFAULT_SPAWN_RATE
var nugget_value: int
var dead: bool = false
@export var spawn_factories: bool = false

func _ready() -> void:
	#sprite_2d.material = sprite_2d.material.duplicate()
	shader_material = sprite_2d.material
	area_entered.connect(_on_area_2d_bubble_area_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(bubble_deleted)
	nugget_value = (bubble_level+1)*3
	velocity = Util.rand_on_circle()
	speed = randf_range(100.0,200.0) / (1.0+bubble_level/1.5)
	
	
	match bubble_level:
		#Small Bubble
		0:
			set_color(Color.SKY_BLUE)
			set_collision_layer_value(3, false)
			set_collision_mask_value(3, false)
			if BubbleManager.stonk_value > 0:
				stonk_count = BubbleManager.stonk_value
				set_color(Color.DARK_GREEN)
		#Factory Bubble
		1:
			scale *= 3
			set_bubble_pop_spawn_qty(75)
			set_bubble_factory()
			set_color(Color.HOT_PINK)
			set_collision_mask_value(5, false)
		#Special Bubble
		2:
			
			set_bubble_pop_spawn_qty(115)
			set_bubble_factory()
			shader_material.set_shader_parameter("wobble_strength", 0.05)
			set_collision_mask_value(5, false)
			
			scale = Vector2.ZERO
			var scale_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			scale_tween.tween_property(self, "scale", Vector2.ONE * 4, 2.0)
			
		#Huge Bubble (Intro)
		3:
			set_bubble_pop_spawn_qty(8)
			set_bubble_factory()
			spawn_factories = true
			set_color(Color.WHITE)
			set_collision_mask_value(5, false)
			
			scale = Vector2.ZERO
			var scale_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			scale_tween.tween_property(self, "scale", Vector2.ONE * 7, 2.0)
	
	
	if bubble_types.size() > 0:
		for type in bubble_types:
			match type:
				BubbleManager.BUBBLE_DIVIDEND:
					set_bubble_dividend()
				BubbleManager.BUBBLE_DIVIDEND_CHILDREN:
					set_bubble_dividend_children()
				BubbleManager.BUBBLE_SPECULATIVE:
					set_bubble_speculative()
				BubbleManager.BUBBLE_STONK:
					set_bubble_stonk()
				BubbleManager.BUBBLE_GPT:
					set_bubble_gpt()
				BubbleManager.BUBBLE_INTERNET:
					set_bubble_internet()
				BubbleManager.BUBBLE_SPIKE:
					set_bubble_spike()
				BubbleManager.BUBBLE_SPIKE_CHILDREN:
					set_bubble_spike_children()
				BubbleManager.BUBBLE_CRASH:
					set_bubble_crash()
				BubbleManager.BUBBLE_SHIELDING:
					set_bubble_shielding()
	
	
func _physics_process(delta: float) -> void:
	if dead:
		return
	position += velocity * speed * speed_start_mult * BubbleManager.bubble_speed_mult * delta
	
	
func _on_area_2d_bubble_area_entered(area: Area2D) -> void:
	if dead:
		return
	if area is Bubble and not area.dead:
		if is_spike_children:
			area.bubble_popped()
			#play explode sound
		AudioManager.play_bubble_collision()
		var opposite_vector : Vector2 = (global_position - area.global_position).normalized()
		velocity = velocity.bounce(opposite_vector)
	elif area.get_parent() is Hand:
		AudioManager.play_bubble_collision()
		var opposite_vector : Vector2 = (global_position - area.global_position).normalized()
		velocity = opposite_vector * 5.0
		
func set_bubble_stonk(stonk_value: int = 3)-> void:
	is_stonk = true
	Global.stonk_bubble_count += 1
	set_color(Color.DARK_GREEN)
	set_bubble_pop_spawn_qty(175)
	BubbleManager.stonk_value = stonk_value
	for bubble in Global.all_bubbles:
		if bubble.bubble_level == 0:
			bubble.stonk_count = BubbleManager.stonk_value
			bubble.set_color(Color.DARK_GREEN)
		
func set_bubble_speculative()-> void:
	is_speculative = true
	Global.speculative_bubble_count += 1
	set_bubble_pop_spawn_qty(75)
	set_color(Color.GREEN)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	timer_speculative = Timer.new()
	timer_speculative.one_shot = true
	add_child(timer_speculative)
	timer_speculative.timeout.connect(grow_speculative_bubble)
	timer_speculative.start(3.0)
		
func set_bubble_dividend()-> void:
	is_dividend = true
	Global.dividend_bubble_count += 1
	set_bubble_pop_spawn_qty(50)
	set_color(Color.ORANGE_RED)
	
func set_bubble_dividend_children()-> void:
	spawn_rate = 0
	set_color(Color.ORANGE_RED)
	timer_dividend = Timer.new()
	timer_dividend.one_shot = true
	add_child(timer_dividend)
	timer_dividend.timeout.connect(create_bubble.bind(timer_dividend, Vector2(7.0,7.0), true, 0, 1, [BubbleManager.BUBBLE_DIVIDEND_CHILDREN]))
	timer_dividend.start(7.0)
	
func set_bubble_spike()-> void:
	is_spike = true
	Global.spike_bubble_count += 1
	set_bubble_pop_spawn_qty(50)
	set_color(Color.BLACK)
	
func set_bubble_spike_children()-> void:
	is_spike_children = true
	set_color(Color.BLACK)
	sprite_2d.texture = BUBBLE_SPIKE
	sprite_2d.material = null
	set_collision_mask_value(3, true)
	
	
func set_bubble_factory()-> void:
	is_factory = true
	Global.factory_bubble_count += 1
	spawn_rate = 50
	timer_factory = Timer.new()
	timer_factory.one_shot = true
	add_child(timer_factory)
	timer_factory.timeout.connect(create_bubble.bind(timer_factory, Vector2(1.0,factory_max_range_timer), true, 0, 2))
	timer_factory.start(1.0)
	
func set_bubble_internet(activate: bool = true)-> void:
	if activate:
		is_internet = true
		Global.internet_bubble_count += 1
		set_color(Color.GRAY)
		set_bubble_pop_spawn_qty(175)
		for bubble : Bubble in Global.all_bubbles:
			if bubble.is_factory:
				bubble.spawn_rate = 0
				bubble.factory_max_range_timer = 1.5
	else:
		for bubble : Bubble in Global.all_bubbles:
			if bubble.is_factory:
				bubble.spawn_rate = bubble.DEFAULT_SPAWN_RATE
				bubble.factory_max_range_timer = bubble.DEFAULT_FACTORY_MAX_RANGE_TIMER
		
	
func set_bubble_gpt(activate: bool = true)-> void:
	if activate:
		is_gpt = true
		Global.gpt_bubble_count += 1
		set_color(Color.RED)
		Global.main_node.player_hand.area.set_collision_layer_value(5, true)
	else:
		Global.main_node.player_hand.area.set_collision_layer_value(5, false)
		
		
		
func set_bubble_crash()->void:
	is_crash = true
	Global.crash_bubble_count += 1
	set_bubble_pop_spawn_qty(50)
	set_color(Color.DARK_RED)
	
func get_nearby_bubble(max_distance: float) -> Array:
	var nearby_bubbles: Array[Bubble] = []
	var max_distance_sq := max_distance * max_distance
	for bubble in Global.all_bubbles:
		if bubble != self and global_position.distance_squared_to(bubble.global_position) <= max_distance_sq:
			nearby_bubbles.append(bubble)
	return nearby_bubbles
	
func update_range_explosion_sprite(max_distance: float) -> void:
	var diameter := max_distance * 2.0
	sprite_2d_explosion_radius.scale = Vector2.ONE * (diameter / 512)

func set_bubble_shielding()-> void:
	is_shielding = true
	Global.shielding_bubble_count += 1
	set_color(Color.DARK_BLUE)
	var valid_bubbles: Array[Bubble] = []

	for bubble in Global.all_bubbles:
		if bubble.bubble_level > 0 and bubble != self:
			valid_bubbles.append(bubble)
	if !valid_bubbles.is_empty():
		shielded_bubble = valid_bubbles.pick_random()
		shielded_bubble.set_bubble_shielded()
		
func set_bubble_shielded(activate: bool = true)-> void:
	if activate:
		is_shielded = true
		shader_material.set_shader_parameter("rim_color", Color.DARK_BLUE)
	else:
		is_shielded = false
		shader_material.set_shader_parameter("rim_color", bubble_color+Color(0.1,0.1,0.1,0.0))
	
	


func create_bubble(timer: Timer, timer_range : Vector2, is_self_pos : bool, level: int, qty: int = 1, types: Array = [])-> void:
	#25% luck to spawn bubble with spawn_rate = 75
	if randi() % 101 > spawn_rate:
		var pos : Vector2
		if is_self_pos:
			pos = Vector2(position.x+randf_range(-1.0,1.0), position.y+randf_range(-1.0,1.0))
		else:
			pos = Util.rand_in_rectangle(Global.main_node.spawn_rect)
		
		if !is_crash:
			var original_scale := scale
			var tmp_scale_tween : Tween= create_tween()
			tmp_scale_tween.set_trans(Tween.TRANS_BACK)
			tmp_scale_tween.set_ease(Tween.EASE_OUT)
			tmp_scale_tween.tween_property(self, "scale", original_scale + Vector2.ONE, 0.1)
			tmp_scale_tween.set_ease(Tween.EASE_IN)
			tmp_scale_tween.tween_property(self, "scale", original_scale, 0.2)
		
		Global.main_node.spawn_bubble(pos, level, qty, types)
		
	timer.start(randf_range(timer_range.x, timer_range.y))
	
func grow_speculative_bubble():
	timer_speculative.start(3.0)
	#play grow sound
	bubble_pop_spawn_qty += 5
	var grow_sacle = scale + Vector2(1.0,1.0)
	var scale_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	scale_tween.tween_property(self, "scale", grow_sacle, 1.0)

	

func bubble_popped()-> void:
	if dead:
		return
	if stonk_count > 0:
		stonk_count-=1
		scale*=1.2
		audio_stream_player_2d_bubble_up.play()
		audio_stream_player_2d_bubble_up.pitch_scale += 0.2
	elif is_shielded:
		#play shield sound
		return
	else:
		remove_bubble()
		AudioManager.playAudio_stream_sfx(&"bubble_pop" if bubble_level == 0 else &"bubble_pop_big")
		popped.emit(false)
	
func bubble_deleted()-> void:
	if dead:
		return
	remove_bubble(true)
	
func remove_bubble(is_deleted : bool = false)-> void:
	if bubble_level == 2:
		BubbleManager.special_bubble_count -= 1
	if is_stonk:
		Global.stonk_bubble_count -= 1
		if Global.stonk_bubble_count <= 0:
			BubbleManager.stonk_value = 0
			for bubble in Global.all_bubbles:
				if bubble.bubble_level == 0:
					bubble.stonk_count = BubbleManager.stonk_value
					bubble.set_color(Color.SKY_BLUE)
	if is_speculative:
		Global.speculative_bubble_count -= 1
	if is_dividend:
		Global.dividend_bubble_count -= 1
		if !is_deleted:
			for bubble in Global.all_bubbles:
				if bubble.bubble_level == 0:
					bubble.set_bubble_dividend_children()
	if is_factory:
		Global.factory_bubble_count -=1
	if is_gpt:
		Global.gpt_bubble_count -=1
		if Global.gpt_bubble_count <= 0:
			set_bubble_gpt(false)
	if is_internet:
		Global.internet_bubble_count -=1
		if Global.internet_bubble_count <= 0:
			set_bubble_internet(false)
	if is_spike:
		Global.spike_bubble_count -= 1
		if !is_deleted:
			for bubble in Global.all_bubbles:
				if bubble.bubble_level == 0:
					bubble.set_bubble_spike_children()
	if is_shielding:
		Global.shielding_bubble_count -= 1
		if shielded_bubble:
			shielded_bubble.set_bubble_shielded(false)
	if is_crash:
		Global.crash_bubble_count -= 1
		#show explosion visual
		var nearby_bubbles : Array[Bubble] = get_nearby_bubble(explosion_radius)
		print(nearby_bubbles)
		for bubble : Bubble in nearby_bubbles:
			bubble.bubble_popped()
		
		
	
func set_color(color: Color):
	bubble_color = color
	shader_material.set_shader_parameter("bubble_color", bubble_color)
	shader_material.set_shader_parameter("rim_color", bubble_color+Color(0.1,0.1,0.1,0.0))
	
	
func set_bubble_pop_spawn_qty(qty: int)-> void:
	bubble_pop_spawn_qty = qty
	label_pop_spawn_qty.text = str(bubble_pop_spawn_qty)
	
func switch_pop_spawn_qty_visibility(mouse_hover: bool = true)-> void:
	if mouse_hover and bubble_pop_spawn_qty > 0:
		label_pop_spawn_qty.show()
	else:
		label_pop_spawn_qty.hide()

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


func _on_mouse_entered() -> void:
	label_pop_spawn_qty.text = str(bubble_pop_spawn_qty)
	label_pop_spawn_qty.show()
	if is_crash:
		update_range_explosion_sprite(explosion_radius)
		sprite_2d_explosion_radius.scale = Vector2.ONE/scale
		sprite_2d_explosion_radius.show()


func _on_mouse_exited() -> void:
	label_pop_spawn_qty.hide()
	if is_crash:
		sprite_2d_explosion_radius.hide()
