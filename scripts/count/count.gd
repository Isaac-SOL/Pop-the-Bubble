class_name Count extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

@export var parent: Node
@export var anim_interval: float = 0.5
@export var anim_pos_accel: float = 1.0
@export var anim_rot_accel: float = 1.0
@export var anim_scale_accel: float = 1.0
@export var anim_pos_max_der: float = 10.0
@export var anim_rot_max_der: float = 2.0
@export var anim_scale_max_der: float = 1.0

var rand_range: Vector2 = Vector2(10, 20)
var rand_timer: Timer

var voice_tween: Tween

var anim_wait: float = 100.0
var anim_tgt_pos: Vector2
var anim_tgt_rot: float
var anim_tgt_scale: float
var anim_pos_der: Vector2 = Vector2.ZERO
var anim_rot_der: float = 0.0
var anim_scale_der: float = 0.0

func _process(delta: float) -> void:
	anim_wait += delta
	if anim_wait >= anim_interval:
		anim_interval -= anim_interval
		anim_tgt_pos = Util.rand_in_circle(100.0, 300.0)
		anim_tgt_rot = randf_range(-PI/32, PI/32)
		anim_tgt_scale = randf_range(0.95, 1.05)
	anim_pos_der += sign(anim_tgt_pos - %AnimPivot.position) * anim_pos_accel * delta
	anim_rot_der += sign(anim_tgt_rot - %AnimPivot.rotation) * anim_rot_accel * delta
	anim_scale_der += sign(anim_tgt_scale - %AnimPivot.scale.x) * anim_scale_accel * delta
	anim_pos_der = anim_pos_der.clampf(-anim_pos_max_der, anim_pos_max_der)
	anim_rot_der = clampf(anim_rot_der, -anim_rot_max_der, anim_rot_max_der)
	anim_scale_der = clampf(anim_scale_der, -anim_scale_max_der, anim_scale_max_der)
	%AnimPivot.position += anim_pos_der * delta
	%AnimPivot.rotation += anim_rot_der * delta
	%AnimPivot.scale += Vector2.ONE * anim_scale_der * delta

func start_doing_actions():
	rand_timer = Timer.new()
	rand_timer.one_shot = true
	add_child(rand_timer)
	rand_timer.timeout.connect(count_action)
	rand_timer.start(randf_range(rand_range.x,rand_range.y))

func count_action()->void:
	BubbleManager.spawn_random_special_bubble()
	rand_timer.start(randf_range(rand_range.x,rand_range.y))
	rand_range.y += 1

func voice_bleep():
	if voice_tween != null:
		voice_tween.kill()
	%AnimVoice.scale = Vector2.ONE * 1.1
	voice_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	voice_tween.tween_property(%AnimVoice, "scale", Vector2.ONE, 0.2)
	%AudioStreamPlayer.play()

func shake():
	%Shaker2D.shake(1.0, 1.0)


func _on_animated_sprite_2d_animation_changed() -> void:
	match %AnimatedSprite2D.animation:
		&"surpris":
			%Perruque.show()
			%Perruque.position = Vector2(0.0, -150.0)
			var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
			tween.tween_property(%Perruque, "position", Vector2.ZERO, 0.6)
		&"vener":
			%Perruque.show()
			%Perruque.position = Vector2.ZERO
			var tween := create_tween()
			tween.tween_property(%Perruque, "position", Vector2(0.0, -1000.0), 0.6)
		_:
			%Perruque.hide()
