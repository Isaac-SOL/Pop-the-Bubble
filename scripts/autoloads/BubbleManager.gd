extends Node

const LABEL_DEFAULT_SETTINGS = preload("uid://b56puo2v5fv7b")

#Power ID
const BUBBLE_GPT : String = "GPT Bubble"
const BUBBLE_STONK : String = "Bubble Stonk"
const BUBBLE_SPECULATIVE : String = "Speculative Bubble"
const BUBBLE_DIVIDEND : String = "Dividend Bubble"
const BUBBLE_DIVIDEND_CHILDREN: String = "Dividend Children Bubble"
const BUBBLE_INTERNET : String = "Internet Bubble"
const BUBBLE_SPIKE : String = "Spike Bubble"
const BUBBLE_SPIKE_CHILDREN : String = "Spike Children Bubble"
const BUBBLE_CRASH : String = "Crash Bubble"
const BUBBLE_SHIELDING : String = "Shielding Bubble"


var special_bubble_count : int = 0
var bubble_speed_mult = 1.0
var phase_powers: Array
var current_powers : Array
var stonk_value : int = 0



func spawn_special_bubble(power_id: String)-> void:
	print("New special bubble : "+power_id)
	if special_bubble_count >= 2:
		return
	match power_id:
		BUBBLE_GPT:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 2, 1, [BUBBLE_GPT])
			special_bubble_count += 1
			
		BUBBLE_STONK:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 2, 1, [BUBBLE_STONK])
			special_bubble_count += 1
			
		BUBBLE_SPECULATIVE:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 2, 1, [BUBBLE_SPECULATIVE])
			special_bubble_count += 1
			
		BUBBLE_DIVIDEND:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 2, 1, [BUBBLE_DIVIDEND])
			special_bubble_count += 1
				
		BUBBLE_INTERNET:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 2, 1, [BUBBLE_INTERNET])
			special_bubble_count += 1
		
		BUBBLE_SPIKE:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 2, 1, [BUBBLE_SPIKE])
			special_bubble_count += 1
			
		BUBBLE_CRASH:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 2, 1, [BUBBLE_CRASH])
			special_bubble_count += 1
			
		BUBBLE_SHIELDING:
			Global.main_node.spawn_bubble(Util.rand_in_rectangle(Global.main_node.spawn_rect), 2, 1, [BUBBLE_SHIELDING])
			special_bubble_count += 1
			

			
			
func get_random_power()-> String:
	if phase_powers.size() > 0:
		var rand_power : int = randi_range(0,phase_powers.size()-1)
		return phase_powers[rand_power] 
	return ""

func spawn_random_special_bubble():
	spawn_special_bubble(get_random_power())
	
	
