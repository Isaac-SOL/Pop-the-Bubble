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
@onready var label_bubbles_spike: Label = %LabelBubblesSpike
@onready var label_bubbles_shielding: Label = %LabelBubblesShielding
@onready var label_bubbles_crash: Label = %LabelBubblesCrash

func _physics_process(_delta: float) -> void:
	SettingsManager.apply_mouse_scale()
	
	if Global.factory_bubble_count > 0:
		label_bubbles_factory.show()
		label_bubbles_factory.text = "Factory Bubbles: "+str(Global.factory_bubble_count)+"\n(Spawns small bubbles)"
	else:
		label_bubbles_factory.hide()
		
	if Global.stonk_bubble_count > 0:
		label_bubbles_stonk.show()
		label_bubbles_stonk.text = "Stonk Bubbles: "+str(Global.stonk_bubble_count)+"\n(Makes other bubbles stronger)"
	else:
		label_bubbles_stonk.hide()
		
	if Global.speculative_bubble_count > 0:
		label_bubbles_speculative.show()
		label_bubbles_speculative.text = "Speculative Bubbles: "+str(Global.speculative_bubble_count)+"\n(Increases in size and value)"
	else:
		label_bubbles_speculative.hide()
		
	if Global.dividend_bubble_count > 0:
		label_bubbles_dividend.show()
		label_bubbles_dividend.text = "Dividend Bubbles: "+str(Global.dividend_bubble_count)+"\n(When exploded, transforms other \nbubbles in duplicative bubbles)"
	else:
		label_bubbles_dividend.hide()
		
	if Global.internet_bubble_count > 0:
		label_bubbles_iternet.show()
		label_bubbles_iternet.text = "Internet Bubbles: "+str(Global.internet_bubble_count)+"\n(Increases spawn rates \nof other bubbles)"
	else:
		label_bubbles_iternet.hide()
		
	if Global.shielding_bubble_count > 0:
		label_bubbles_shielding.show()
		label_bubbles_shielding.text = "Shielding Bubbles: "+str(Global.shielding_bubble_count)+"\n(Gives a shield to another bubble)"
	else:
		label_bubbles_shielding.hide()
		
	if Global.crash_bubble_count > 0:
		label_bubbles_crash.show()
		label_bubbles_crash.text = "Crash Bubbles: "+str(Global.crash_bubble_count)+"\n(When exploded, also explods \nsurrounding bubbles)"
	else:
		label_bubbles_crash.hide()
		
	if Global.gpt_bubble_count > 0:
		label_bubbles_gpt.show()
		label_bubbles_gpt.text = "GPT Bubbles: "+str(Global.gpt_bubble_count)+"\n(Makes small bubbles \nrunaway from you)"
	else:
		label_bubbles_gpt.hide()
		
	if Global.spike_bubble_count > 0:
		label_bubbles_spike.show()
		label_bubbles_spike.text = "Spike Bubbles: "+str(Global.spike_bubble_count)+"\n(When exploded, small bubbles \nbecome spiky)"
	else:
		label_bubbles_spike.hide()
		
	label_bubbles.text = str(Global.all_bubbles.size()) +" / "+ str(int(%BubbleBar.max_value)) + " Bubbles"
	%BubbleBar.value = Global.all_bubbles.size()
