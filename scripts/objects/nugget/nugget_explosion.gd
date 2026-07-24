extends Node2D

@export var nugget_texture: Texture2D
@export var magnetism_speed : float = 900.0
@export var explosion_min_speed : float = 50.0
@export var explosion_max_speed : float = 500.0
@export var explosion_acceleration : float = 0.95

class Nugget:
	var position: Vector2
	var velocity: Vector2
	var rotation: float
	var rotation_speed: float
	var timer: float
	
var nuggets_list: Array[Nugget] = []
var collect_target: Node2D

func spawn(amount: int, pos: Vector2, target: Node2D):
	global_position = Vector2.ZERO
	collect_target = target
	nuggets_list.clear()
	
	for i in amount:
		var n := Nugget.new()
		n.position = pos
		var angle = randf() * TAU
		var speed = randf_range(explosion_min_speed, explosion_max_speed)
		n.velocity = Vector2.RIGHT.rotated(angle) * speed
		n.rotation = randf() * TAU
		n.rotation_speed = randf_range(-10.0, 10.0)
		n.timer = randf_range(0.4, 0.7)
		nuggets_list.append(n)
	queue_redraw()


func _physics_process(delta):
	if nuggets_list.is_empty():
		queue_free()
		return
		
	for i in range(nuggets_list.size()-1, -1, -1):
		var nugget = nuggets_list[i]
		if nugget.timer > 0:
			nugget.timer -= delta
			nugget.velocity *= explosion_acceleration
		else:
			var dir = (collect_target.global_position - nugget.position).normalized()
			nugget.velocity = nugget.velocity.lerp(dir * magnetism_speed, 8.0 * delta)
		nugget.position += nugget.velocity * delta
		nugget.rotation += nugget.rotation_speed * delta
		if nugget.position.distance_to(collect_target.global_position) < 10.0:
			#Add something to decrease the BPS
			Global.nugget_collected += 1
			nuggets_list.remove_at(i)
	queue_redraw()


func _draw():
	if nugget_texture == null:
		return
	var offset = nugget_texture.get_size() * 0.5
	
	for nugget in nuggets_list:
		draw_set_transform(nugget.position, nugget.rotation, Vector2.ONE)
		draw_texture(nugget_texture, -offset)
		
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
