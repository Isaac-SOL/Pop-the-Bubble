extends Node


var bubble_per_seconds : float = 0

var all_bubbles: Array[Bubble] = []
var bubble_count : int = 0
var nugget_collected : int = 0
#var storm_bubble_count : int = 0
#var metaverse_bubble_count : int = 0
var stonk_bubble_count : int = 0
var dividend_bubble_count : int = 0
var speculative_bubble_count : int = 0
var factory_bubble_count : int = 0
var internet_bubble_count : int = 0
var gpt_bubble_count : int = 0
var spike_bubble_count : int = 0
var crash_bubble_count : int = 0
var shielding_bubble_count : int = 0
var count_phase : int = 0
var can_advance_phase : bool = false

var main_node: Node
func set_main_reference(node: Node)-> void:
	main_node = node

var dialogue_node: DialogueNode2D
func set_dialogue_reference(node: Node) -> void:
	dialogue_node = node

func seconds(t: float) -> Signal:
	return get_tree().create_timer(t, false).timeout
