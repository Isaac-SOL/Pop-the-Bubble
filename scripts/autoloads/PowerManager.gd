extends Node

const LABEL_DEFAULT_SETTINGS = preload("uid://b56puo2v5fv7b")

#Power ID
const BUBBLE_STORM : String = "Bubble Storm"
const BUBBLE_GPT : String = "Bubble GPT"
const BUBBLE_FACTORY : String = "Bubble Factory"

var BUBBLE_POWER_TEST = BUBBLE_GPT


var bubble_speed_mult = 1.0
var phase_powers: Array
var current_powers : Array

func activate_power(power_id: String)-> void:
	print("New power : "+power_id)
	current_powers.append(power_id)
	update_power_list()
	match power_id:
		BUBBLE_STORM:
			phase_powers.erase(power_id)
			bubble_speed_mult = 3.0
			await get_tree().create_timer(8.0).timeout
			bubble_speed_mult = 1.0
			phase_powers.append(power_id)
			current_powers.erase(power_id)
		BUBBLE_GPT:
			phase_powers.erase(power_id)
			Global.main_node.player_hand.set_collision_layer_value(3, true)
			await get_tree().create_timer(8.0).timeout
			Global.main_node.player_hand.set_collision_layer_value(3, false)
			phase_powers.append(power_id)
			current_powers.erase(power_id)
		BUBBLE_FACTORY:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 3, 1, Global.main_node.BUBBLE_SPAWNER)
	update_power_list()
				
			
func update_power_list() -> void:
	var power_ui = Global.main_node.powers_container
	for child in power_ui.get_children():
		child.queue_free()
		
	var counts: Dictionary = {}
	for power in current_powers:
		counts[power] = counts.get(power, 0) + 1
		
	for power in counts:
		var label := Label.new()
		power_ui.add_child(label)
		label.label_settings = LABEL_DEFAULT_SETTINGS
		if counts[power] > 1:
			label.text = power+" x"+str(counts[power])
		else:
			label.text = power

func activate_random_power():
	var rand_power : int = randi_range(0,phase_powers.size()-1)
	activate_power(phase_powers[rand_power])
