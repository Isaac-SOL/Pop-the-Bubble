class_name DialogueNode2D extends Node2D

signal dialogue_passed

const DEFAULT_FADEOUT_TIME = 5 # Secondes

@export var characters_per_sec: float = 5.0
var visible_characters: float = 0.0
var vener_mode: bool = false

func _ready() -> void:
	Global.set_dialogue_reference(self)
	visible = false

func _process(delta: float) -> void:
	visible_characters += delta * characters_per_sec * (2.0 if vener_mode else 1.0)
	%RichTextLabel_dialogue.visible_characters = floori(visible_characters)

func clear_dialogue() -> void:
	visible = false
	%RichTextLabel_dialogue.text = ""

func set_dialogue(text: String, fadeout_time: float = DEFAULT_FADEOUT_TIME, vener: bool = false) -> void:
	visible_characters = 0.0
	%RichTextLabel_dialogue.text = "[font_size=96]%s[/font_size]" % text
	visible = true
	
	vener_mode = vener
	%ChatBubbleNormal.visible = not vener
	%ChatBubbleVener.visible = vener
	
	if vener:
		%Shaker2D.shake(2.0, fadeout_time if fadeout_time > 0.0 else 100.0, Tween.TransitionType.TRANS_QUAD, Tween.EaseType.EASE_IN)
	else:
		%Shaker2D.shake(0.0, 0.0)
	
	if fadeout_time > 0.0:
		await Global.seconds(fadeout_time)
	else:
		await dialogue_passed
	
	clear_dialogue()

func pass_dialogue():
	if %RichTextLabel_dialogue.visible_characters >= %RichTextLabel_dialogue.get_total_character_count():
		dialogue_passed.emit()
