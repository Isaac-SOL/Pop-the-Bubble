extends VBoxContainer

func _ready() -> void:
	# this is ugly but guess what
	# only 17h remaining so oopsie 
	AudioManager.set_music_phase(0)
	Global.count_phase = 0

func _on_custom_button_play_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/level/main.tscn")


func _on_custom_button_credits_button_up() -> void:
	pass


func _on_custom_button_exit_button_up() -> void:
	get_tree().quit()
