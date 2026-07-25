extends Control


@onready var label_bubbles_factory: Label = %LabelBubblesFactory
@onready var label_bubbles_stonk: Label = %LabelBubblesStonk
@onready var label_bubbles: Label = %LabelBubbles
@onready var label_bubbles_speculative: Label = %LabelBubblesSpeculative
@onready var label_bubbles_dividend: Label = %LabelBubblesDividend
@onready var label_bubbles_iternet: Label = %LabelBubblesIternet
@onready var label_bubbles_storm: Label = %LabelBubblesStorm
@onready var label_bubbles_gpt: Label = %LabelBubblesGPT
@onready var label_bubbles_metaverse: Label = %LabelBubblesMetaverse

func _physics_process(_delta: float) -> void:
	SettingsManager.apply_mouse_scale()
	
	if Global.factory_bubble_count > 0:
		label_bubbles_factory.show()
		label_bubbles_factory.text = "Factory Bubbles: "+str(Global.factory_bubble_count)
	else:
		label_bubbles_factory.hide()
		
	if Global.stonk_bubble_count > 0:
		label_bubbles_stonk.show()
		label_bubbles_stonk.text = "Stonk Bubbles: "+str(Global.stonk_bubble_count)
	else:
		label_bubbles_stonk.hide()
		
	if Global.speculative_bubble_count > 0:
		label_bubbles_speculative.show()
		label_bubbles_speculative.text = "Speculative Bubbles: "+str(Global.speculative_bubble_count)
	else:
		label_bubbles_speculative.hide()
		
	if Global.dividend_bubble_count > 0:
		label_bubbles_dividend.show()
		label_bubbles_dividend.text = "Dividend Bubbles: "+str(Global.dividend_bubble_count)
	else:
		label_bubbles_dividend.hide()
		
	if Global.internet_bubble_count > 0:
		label_bubbles_iternet.show()
		label_bubbles_iternet.text = "Internet Bubbles: "+str(Global.internet_bubble_count)
	else:
		label_bubbles_iternet.hide()
		
	if Global.storm_bubble_count > 0:
		label_bubbles_storm.show()
		label_bubbles_storm.text = "Storm Bubbles: "+str(Global.storm_bubble_count)
	else:
		label_bubbles_storm.hide()
		
	if Global.gpt_bubble_count > 0:
		label_bubbles_gpt.show()
		label_bubbles_gpt.text = "GPT Bubbles: "+str(Global.gpt_bubble_count)
	else:
		label_bubbles_gpt.hide()
		
	if Global.metaverse_bubble_count > 0:
		label_bubbles_metaverse.show()
		label_bubbles_metaverse.text = "Metaverse Bubbles: "+str(Global.metaverse_bubble_count)
	else:
		label_bubbles_metaverse.hide()
		
	label_bubbles.text = "Total Bubbles: "+str(Global.all_bubbles.size())
