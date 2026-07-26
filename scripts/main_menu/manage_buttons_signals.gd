extends VBoxContainer

@onready var _bus := AudioServer.get_bus_index("Master")

func _ready() -> void:
	# this is ugly but guess what
	# only 17h remaining so oopsie 
	AudioManager.set_music_phase(0)
	Global.count_phase = 0
	%HSlider.value = AudioServer.get_bus_volume_linear(_bus)

func _on_custom_button_play_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/level/help.tscn")


func _on_custom_button_credits_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/level/credits.tscn")


func _on_custom_button_exit_button_up() -> void:
	get_tree().quit()


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(_bus, value)
