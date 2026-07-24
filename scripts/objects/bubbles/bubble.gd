extends Area2D
class_name Bubble


signal popped(is_deleted : bool)
@warning_ignore("unused_signal")
signal spawn(amount: int, pos: Vector2, level: int)

@onready var sprite_2d: Sprite2D = $bubble_corps/Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $bubble_corps/VisibleOnScreenNotifier2D
@onready var audio_stream_player_2d_bubble_up: AudioStreamPlayer2D = %AudioBubbleUp


@export var bubble_level: int = 0
@export var bubble_color: Color = Color.WHITE
@export var speed_mult_at_start = 6.0


var shader_material : ShaderMaterial
var speed : float
var velocity: Vector2
var bubble_types: Array
var speed_start_mult: float = 1.0
var stonk_count: int = 0
var is_stonk: bool = false
var is_speculative: bool = false
var is_dividend: bool = false
var timer_dividend: Timer
var is_factory: bool = false
var timer_factory: Timer
var factory_spawn_rate: int = 75
var nugget_value: int
var dead: bool = false

func _ready() -> void:
	#sprite_2d.material = sprite_2d.material.duplicate()
	shader_material = sprite_2d.material
	area_entered.connect(_on_area_2d_bubble_area_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(bubble_deleted)
	scale = Vector2(1.0+bubble_level/1.5, 1.0+bubble_level/1.5)
	nugget_value = (bubble_level+1)*3
	if bubble_color == Color.WHITE:
		match bubble_level:
			0:
				bubble_color = Color.SKY_BLUE
			1:
				bubble_color = Color.DARK_BLUE
			2:
				bubble_color = Color.REBECCA_PURPLE
			3:
				bubble_color = Color.RED
			4:
				bubble_color = Color.DARK_RED
				
	
	shader_material.set_shader_parameter("bubble_color", bubble_color)
	shader_material.set_shader_parameter("rim_color", bubble_color+Color(0.1,0.1,0.1,0.0))
	velocity = Vector2(randf_range(-1.0,1.0),randf_range(-1.0,1.0))
	speed = randf_range(50.0,200.0) /scale.x
	
	if bubble_types.size() > 0:
		for type in bubble_types:
			match type:
				PowerManager.BUBBLE_DIVIDEND:
					set_bubble_dividend()
				PowerManager.BUBBLE_FACTORY:
					set_bubble_factory()
				PowerManager.BUBBLE_SPECULATIVE:
					set_bubble_speculative()
				PowerManager.BUBBLE_STONK:
					set_bubble_stonk()
	
	
func _physics_process(delta: float) -> void:
	if dead:
		return
	position += velocity * speed * speed_start_mult * PowerManager.bubble_speed_mult * delta
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
		velocity = opposite_vector * 7.0
		
func set_bubble_stonk(stonk_value: int = 3)-> void:
	if !is_stonk:
		is_stonk = true
		Global.stonk_bubble_count += 1
		stonk_count = stonk_value
		shader_material.set_shader_parameter("rim_color", Color.RED)
		
func set_bubble_speculative()-> void:
	is_speculative = true
	Global.speculative_bubble_count += 1
	shader_material.set_shader_parameter("rim_color", Color.GREEN)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
		
func set_bubble_dividend()-> void:
	is_dividend = true
	Global.dividend_bubble_count += 1
	shader_material.set_shader_parameter("rim_color", Color.YELLOW)
	shader_material.set_shader_parameter("wobble_strenght", 0.2)
	timer_dividend = Timer.new()
	timer_dividend.one_shot = true
	add_child(timer_dividend)
	timer_dividend.timeout.connect(create_dividend_bubble)
	timer_dividend.start(randf_range(3.0,8.0))
	
func set_bubble_factory()-> void:
	is_factory = true
	Global.factory_bubble_count += 1
	shader_material.set_shader_parameter("rim_color", Color.HOT_PINK)
	shader_material.set_shader_parameter("wobble_strenght", 0.1)
	timer_factory = Timer.new()
	timer_factory.one_shot = true
	add_child(timer_factory)
	timer_factory.timeout.connect(create_factory_bubble)
	timer_factory.start(randf_range(3.0,8.0))

func create_dividend_bubble()-> void:
		Global.main_node.spawn_bubble(Vector2(position.x+randf_range(-1.0,1.0), position.y+randf_range(-1.0,1.0)), bubble_level, 1, [PowerManager.BUBBLE_DIVIDEND])
		timer_dividend.start(randf_range(3.0,8.0))
		
func create_factory_bubble()-> void:
		Global.main_node.spawn_bubble(Vector2(position.x+randf_range(-1.0,1.0), position.y+randf_range(-1.0,1.0)), 1, 2)
		timer_factory.start(randf_range(3.0,8.0))

	

func bubble_popped()-> void:
	if dead:
		return
	if stonk_count > 0:
		stonk_count-=1
		scale*=1.2
		audio_stream_player_2d_bubble_up.play()
		audio_stream_player_2d_bubble_up.pitch_scale += 0.2
	else:
		if is_stonk:
			Global.stonk_bubble_count -= 1
		if is_speculative:
			Global.speculative_bubble_count -= 1
		if is_dividend:
			Global.dividend_bubble_count -= 1
		if is_factory:
			Global.factory_bubble_count -=1
			
		AudioManager.playAudio_stream_sfx(&"bubble_pop")			
		popped.emit(false)
	
func bubble_deleted()-> void:
	if dead:
		return
	if is_stonk:
		Global.stonk_bubble_count -= 1
	if is_speculative:
		Global.speculative_bubble_count -= 1
	if is_dividend:
		Global.dividend_bubble_count -= 1
	if is_factory:
		Global.factory_bubble_count -=1
	popped.emit(true)

func on_spawn():
	speed_start_mult = speed_mult_at_start
	var speed_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	speed_tween.tween_property(self, "speed_start_mult", 1.0, 2.0)

func pop_animation():
	dead = true
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	%bubble_corps.hide()
	%Splash.show()
	%Splash.scale = Vector2.ONE * 0.365
	var splash_tween := create_tween().set_trans(Tween.TRANS_QUAD)
	splash_tween.tween_property(%Splash, "scale", Vector2.ONE * 0.4, 0.16).set_ease(Tween.EASE_OUT)
	splash_tween.tween_property(%Splash, "scale", Vector2.ONE * 0.365, 0.16).set_ease(Tween.EASE_IN)
	splash_tween.tween_callback(queue_free)
