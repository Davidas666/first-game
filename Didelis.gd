extends enemy

func _on_mobhp_no_hp():
	Signals.emit_signal("enemy_died", position, state)
	state = DEATH

func _on_mobhp_demage_received():
	state = IDLE
	state = DEMAGE
