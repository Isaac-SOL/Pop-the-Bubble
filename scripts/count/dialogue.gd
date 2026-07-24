class_name DialogueNode2D extends Node2D

const DEFAULT_FADEOUT_TIME = 5 # Secondes

var fadeout_time = DEFAULT_FADEOUT_TIME
var duration_passed = -1.0

func _ready() -> void:
	Global.set_dialogue_reference(self)
	visible = false

func _process(delta: float) -> void:
	if duration_passed >= 0:
		duration_passed += delta
	if duration_passed >= fadeout_time:
		clear_dialogue()

func clear_dialogue() -> void:
	visible = false
	$RichTextLabel_dialogue.text = ""
	duration_passed = -1
	fadeout_time = DEFAULT_FADEOUT_TIME

@warning_ignore("shadowed_variable")
func set_dialogue(text: String, fadeout_time: float = DEFAULT_FADEOUT_TIME) -> void:
	self.fadeout_time = fadeout_time
	duration_passed = 0
	$RichTextLabel_dialogue.text = text
	visible = true
