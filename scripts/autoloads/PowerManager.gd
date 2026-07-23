extends Node

const LABEL_DEFAULT_SETTINGS = preload("uid://b56puo2v5fv7b")

#Power ID
const BUBBLE_STORM : String = "Bubble Storm"
const BUBBLE_GPT : String = "Bubble GPT"

var BUBBLE_POWER_TEST = BUBBLE_GPT


var bubble_speed_mult = 1.0
var current_power : Array

func activate_power(power_id: String)-> void:
	if current_power.has(power_id):
		return
	print("New power : "+power_id)
	current_power.append(power_id)
	update_power_list()
	match power_id:
		BUBBLE_STORM:
			bubble_speed_mult = 3.0
			await get_tree().create_timer(5.0).timeout
			bubble_speed_mult = 1.0
		BUBBLE_GPT:
			Global.main_node.player_hand.set_collision_layer_value(3, true)
			await get_tree().create_timer(5.0).timeout
			Global.main_node.player_hand.set_collision_layer_value(3, false)
	current_power.erase(power_id)
	update_power_list()
				
			
func update_power_list()-> void:
	var power_ui = Global.main_node.v_box_container_powers
	for child in power_ui.get_children():
		child.queue_free()
	for power in current_power:
		print(power)
		var label_instance = Label.new()
		power_ui.add_child(label_instance)
		label_instance.text = power
		label_instance.label_settings = LABEL_DEFAULT_SETTINGS

func activate_random_power():
	var rand_power : int = randi_range(0,1)
	match rand_power:
		0:
			activate_power(BUBBLE_STORM)
		1:
			activate_power(BUBBLE_GPT)
