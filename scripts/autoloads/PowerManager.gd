extends Node

const LABEL_DEFAULT_SETTINGS = preload("uid://b56puo2v5fv7b")

#Power ID
const BUBBLE_STORM : String = "Bubble Storm"
const BUBBLE_GPT : String = "GPT Bubble"
const BUBBLE_FACTORY : String = "Factory Bubble"
const BUBBLE_STONK : String = "Bubble Stonk"
const BUBBLE_METAVERSE : String = "Bubbleverse"
const BUBBLE_SPECULATIVE : String = "Speculative Bubble"

var BUBBLE_POWER_TEST = BUBBLE_GPT



var bubble_speed_mult = 1.0
var phase_powers: Array
var current_powers : Array

func activate_power(power_id: String)-> void:
	print("New power : "+power_id)
	match power_id:
		BUBBLE_STORM:
			update_power_lists(power_id, true)
			bubble_speed_mult = 3.0
			await get_tree().create_timer(8.0).timeout
			bubble_speed_mult = 1.0
			update_power_lists(power_id, false)
		BUBBLE_GPT:
			update_power_lists(power_id, true)
			Global.main_node.player_hand.set_collision_layer_value(3, true)
			await get_tree().create_timer(8.0).timeout
			Global.main_node.player_hand.set_collision_layer_value(3, false)
			update_power_lists(power_id, false)
		BUBBLE_FACTORY:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 3, 1, Global.main_node.BUBBLE_SPAWNER)
		BUBBLE_STONK:
			var bubbles_copy : Array = Global.all_bubbles.duplicate()
			bubbles_copy.shuffle()
			#Select 13 random bubbles
			var random_bubbles : Array = bubbles_copy.slice(0, min(13, bubbles_copy.size()))
			for bubble in random_bubbles:
				bubble.set_bubble_stonk(5)
		BUBBLE_METAVERSE:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 4, 1)
		BUBBLE_SPECULATIVE:
			var bubbles_copy : Array = Global.all_bubbles.duplicate()
			bubbles_copy.shuffle()
			#Select 7 random bubbles
			var random_bubbles : Array = bubbles_copy.slice(0, min(7, bubbles_copy.size()))
			for bubble in random_bubbles:
				bubble.set_bubble_speculative()
			
			
			
				
			
func update_power_lists(power_id, unable: bool) -> void:
	if unable:
		current_powers.append(power_id)
		phase_powers.erase(power_id)
	else:
		current_powers.erase(power_id)
		phase_powers.append(power_id)
		
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
