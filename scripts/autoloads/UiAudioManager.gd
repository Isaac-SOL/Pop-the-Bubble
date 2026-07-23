extends Node

func _ready():
	# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_buttons(get_tree().root)
	get_tree().connect("node_added", _on_SceneTree_node_added)


func _on_SceneTree_node_added(node):
	if node is CustomBubbleButton:
		connect_to_button(node)

# recursively connect all buttons
func connect_buttons(root):
	for child in root.get_children():
		if child is CustomBubbleButton:
			connect_to_button(child)
		connect_buttons(child)

func connect_to_button(button: CustomBubbleButton):
	button.connect("button_down", _on_Button_pressed)


func _on_Button_pressed():
	AudioManager.playAudio_stream_sfx(&"bubble_button")
