extends Node


var bubble_per_seconds : int = 0

var all_bubbles: Array[Bubble] = []
var bubble_count : int = 0
var stonk_bubble_count : int = 0
var factory_bubble_count : int = 0

var main_node: Node
	
func set_main_reference(node: Node)-> void:
	main_node = node
