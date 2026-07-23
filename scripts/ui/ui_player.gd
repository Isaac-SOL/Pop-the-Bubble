extends Control


@onready var label_bubbles_factory: Label = %LabelBubblesFactory
@onready var label_bubbles_stonk: Label = %LabelBubblesStonk
@onready var label_bubbles: Label = %LabelBubbles

func _physics_process(_delta: float) -> void:
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
		
	if Global.all_bubbles.size() > 0:
		label_bubbles.show()
		label_bubbles.text = "Total Bubbles: "+str(Global.all_bubbles.size())
	else:
		label_bubbles.hide()
