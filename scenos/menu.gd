extends Node2D




func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenos/level.tscn")
	


func _on_exitbtn_pressed():
	get_tree().quit()
