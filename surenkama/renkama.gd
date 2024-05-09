extends Node2D

var coin11 = preload("res://surenkama/coin.tscn")
var skull11 = preload("res://surenkama/skull.tscn")
func _ready():
	Signals.connect("enemy_died", Callable (self, "_on_ennemy_died"))

func _on_ennemy_died(enemy_position,state):
	if state != 4:
		for i in randi_range(1,6):
			coin_spawn(enemy_position)
			await get_tree().create_timer(0.05).timeout
		for i in randi_range(1,2):
			skull_spawn(enemy_position)


func coin_spawn(pos):
	var coin = coin11.instantiate()
	coin.position = pos
	call_deferred("add_child",coin)

func skull_spawn(pos):
	var skull = skull11.instantiate()
	skull.position = pos
	call_deferred("add_child",skull)
