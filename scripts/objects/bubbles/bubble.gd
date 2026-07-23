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

var shader_material : ShaderMaterial
var speed : float
var velocity: Vector2
var stonk_count: int =0
var is_stonk: bool = false

func _ready() -> void:
	sprite_2d.material = sprite_2d.material.duplicate()
	shader_material = sprite_2d.material
	area_entered.connect(_on_area_2d_bubble_area_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(bubble_deleted)
	scale = Vector2(1.0+bubble_level/1.5, 1.0+bubble_level/1.5)
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
	position += velocity * speed * PowerManager.bubble_speed_mult * delta
	
	
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
		
func bubble_popped()-> void:
	if stonk_count > 0:
		stonk_count-=1
		scale*=1.2
		audio_stream_player_2d_bubble_up.play()
		audio_stream_player_2d_bubble_up.pitch_scale += 0.2
	else:
		if is_stonk:
			Global.stonk_bubble_count -= 1
		AudioManager.playAudio_stream_sfx(&"bubble_pop")
		popped.emit(false)
	
func bubble_deleted()-> void:
	if is_stonk:
		Global.stonk_bubble_count -= 1
	popped.emit(true)

	
