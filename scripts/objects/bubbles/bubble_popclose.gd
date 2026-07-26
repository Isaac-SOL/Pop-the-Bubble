class_name BubblePopClose extends Bubble

const WARNING_LINE = preload("uid://dxcm58nww0fg6")

var to_pop: Array[Bubble] = []
var warning_lines: Array[Line2D] = []

func _process(_delta: float) -> void:
	if dead:
		return
	for i in range(to_pop.size()):
		warning_lines[i].set_point_position(1, to_local(to_pop[i].global_position))

func bubble_popped()-> void:
	if dead:
		return
	super.bubble_popped()
	for bubble: Bubble in to_pop:
		bubble.bubble_popped()

func pop_animation():
	super.pop_animation()
	for line: Line2D in warning_lines:
		line.hide()

func _on_pop_area_area_entered(area: Area2D) -> void:
	if area is Bubble and area != self:
		to_pop.append(area)
		var new_line: Line2D = WARNING_LINE.instantiate()
		add_child(new_line)
		warning_lines.append(new_line)


func _on_pop_area_area_exited(area: Area2D) -> void:
	if area is Bubble and area != self:
		var idx := to_pop.find(area)
		to_pop.remove_at(idx)
		warning_lines[idx].queue_free()
		warning_lines.remove_at(idx)
