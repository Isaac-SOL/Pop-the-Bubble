extends Area2D
class_name Bubble


signal popped(is_deleted : bool)
@warning_ignore("unused_signal")
signal spawn(amount: int, pos: Vector2, level: int)

@onready var sprite_2d: Sprite2D = $bubble_corps/Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $bubble_corps/VisibleOnScreenNotifier2D
@onready var audio_stream_player_2d_bubble_up: AudioStreamPlayer2D = $bubble_corps/AudioStreamPlayer2D_BubbleUp


@export var bubble_level: int = 0
@export var bubble_color: Color = Color.WHITE
@export var speed_mult_at_start = 6.0

var shader_material : ShaderMaterial
var speed : float
var velocity: Vector2
var speed_start_mult: float = 1.0
var stonk_count: int = 0
var is_stonk: bool = false
var is_speculative: bool = false
var nugget_value: int

func _ready() -> void:
	sprite_2d.material = sprite_2d.material.duplicate()
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
	
	
func _physics_process(delta: float) -> void:
	position += velocity * speed * speed_start_mult * PowerManager.bubble_speed_mult * delta
	if is_speculative:
		scale += Vector2(delta,delta)
	
	
func _on_area_2d_bubble_area_entered(area: Area2D) -> void:
	if area is Bubble:
		AudioManager.play_bubble_collision()
		var opposite_vector : Vector2 = (global_position - area.global_position).normalized()
		velocity = opposite_vector
	elif area is Hand:
		AudioManager.play_bubble_collision()
		var opposite_vector : Vector2 = (global_position - area.global_position).normalized()
		velocity = opposite_vector * 7.0
		
func set_bubble_stonk(stonk_value: int = 3)-> void:
	if !is_stonk:
		is_stonk = true
		Global.stonk_bubble_count += 1
		stonk_count = stonk_value
		shader_material.set_shader_parameter("rim_color", Color.RED)
		
func set_bubble_speculative():
	is_speculative = true
	Global.speculative_bubble_count += 1
	shader_material.set_shader_parameter("rim_color", Color.GREEN)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
		
func bubble_popped()-> void:
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
		AudioManager.playAudio_stream_sfx(&"bubble_pop")
		if bubble_level > 3:
			Global.main_node.spawn_bubble(self.global_position, bubble_level-2, bubble_level, Global.main_node.BUBBLE_SPAWNER)
		popped.emit(false)
	
func bubble_deleted()-> void:
	if is_stonk:
		Global.stonk_bubble_count -= 1
	popped.emit(true)

func on_spawn():
	speed_start_mult = speed_mult_at_start
	var speed_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	speed_tween.tween_property(self, "speed_start_mult", 1.0, 2.0)
