extends Node2D

@onready var mobs = $".."
@onready var animation_player = $AnimationPlayer

var mushroom_preload = preload("res://priesas/grybas.tscn")
var gigant_preload = preload("res://priesas/didelis.tscn")
var spawn_kiek = 0
var dienos = Global1.dienu_kiek
func _ready():
	animation_player.play("idle")
	Signals.connect("day_time",Callable(self, "_on_time_changed"))

func _on_time_changed(state):
	spawn_kiek = 0
	var rng = randi_range(0,2)
	var z = Global1.dienu_kiek+rng
	if state == 1:
		for i in (z):
			animation_player.play("spawn")
			await animation_player.animation_finished
			spawn_kiek += 1

	if spawn_kiek == Global1.dienu_kiek+rng:
		animation_player.play("idle")

func enemy_spawn():
	var rng = randi_range(1,2)
	if rng == 1:
		grybu_spawn()
	elif rng == 2:
		didelis_spawn()

func grybu_spawn():
	var grybas = mushroom_preload.instantiate()
	grybas.position = Vector2(self.position.x,500)
	mobs.add_child(grybas)

func didelis_spawn():
	var didelis = gigant_preload.instantiate()
	didelis.position = Vector2(self.position.x,500)
	mobs.add_child(didelis)
