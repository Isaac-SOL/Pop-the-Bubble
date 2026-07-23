extends Bubble
class_name BubbleSpawner

func bubbles_per_second() -> int:
	return 1

func _on_timer_timeout() -> void:
	spawn.emit(1)
