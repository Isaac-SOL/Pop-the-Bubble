extends Node

const LABEL_DEFAULT_SETTINGS = preload("uid://b56puo2v5fv7b")

#Power ID
const BUBBLE_STORM : String = "Bubble Storm"
const BUBBLE_GPT : String = "GPT Bubble"
const BUBBLE_FACTORY : String = "Factory Bubble"
const BUBBLE_STONK : String = "Bubble Stonk"
const BUBBLE_METAVERSE : String = "Bubbleverse"
const BUBBLE_SPECULATIVE : String = "Speculative Bubble"
const BUBBLE_DIVIDEND : String = "Dividend Bubble"
const BUBBLE_INTERNET : String = "Internet Bubble"


var bubble_speed_mult = 1.0
var phase_powers: Array
var current_powers : Array



func activate_power(power_id: String)-> void:
	print("New power : "+power_id)
	match power_id:
		BUBBLE_STORM:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 3, 1, [BUBBLE_STORM])
			
		BUBBLE_GPT:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 3, 1, [BUBBLE_GPT])
			
		BUBBLE_FACTORY:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 3, 2, [BUBBLE_FACTORY])
			
		BUBBLE_STONK:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 1, 13, [BUBBLE_STONK])
			
		BUBBLE_METAVERSE:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 3, 1, [BUBBLE_METAVERSE])
			
		BUBBLE_SPECULATIVE:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 2, 7, [BUBBLE_SPECULATIVE])
			
		BUBBLE_DIVIDEND:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 0, 2, [BUBBLE_DIVIDEND])
				
		BUBBLE_INTERNET:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 3, 1, [BUBBLE_INTERNET])
			
			
			
			
				
			
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
	if phase_powers.size() > 0:
		var rand_power : int = randi_range(0,phase_powers.size()-1)
		activate_power(phase_powers[rand_power])
