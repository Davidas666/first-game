extends CanvasLayer

@onready var goldtxt = $Control/PanelContainer/HBoxContainer/goldtxt
@onready var skullxt = $Control/PanelContainer/HBoxContainer/skulltxt
func _process(delta):
	goldtxt.text = str(Global1.gold)
	skullxt.text = str(Global1.skull)
