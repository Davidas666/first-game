extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_pressed():
	$".".visible = false


func _on__pressed():
	if Global1.gold > 499:
		Global1.max_hp = 300
		Global1.hp = 300
		Global1.gold -= 500
	else:
		pass





func for_skull():
	if Global1.skull > 99:
		Global1.skull -= 10
		Global1.basic_demage = 30
	else:
		pass


func for_100_100hp():
	if Global1.gold > 99:
		Global1.max_hp = 100
		Global1.hp += 100
		Global1.gold -= 300
	else:
		pass

func X2_DEMAGE():
	if Global1.skull > 9:
		Global1.skull -= 10
		Global1.basic_demage = 20
	else:
		pass
