class_name BubbleSpawner extends Bubble

func bubbles_per_second() -> int:
	return 1

func _on_timer_timeout() -> void:
	spawn.emit(1)
