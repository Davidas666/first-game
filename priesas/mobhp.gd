extends Node2D

signal no_hp()
signal demage_received()

@onready var hpbar = $hpbar
@onready var demagetext = $demagetext
@onready var anim = $AnimationPlayer
var player_dmg
var maxhp = 100
@export var hp = 100:
	set(value):
		hp = value
		hpbar.value = hp
		hpbar.visible = true

func _ready():
	Signals.connect("player_attack", Callable (self, "_on_demage_received"))
	demagetext.modulate.a = 0
	hpbar.max_value = maxhp
	hp = maxhp
	hpbar.visible = false

func _on_demage_received(player_demage1):
	player_dmg = player_demage1


func _on_hurt_box_area_entered(_area):
	await get_tree().create_timer(0.1).timeout
	hp -=Global1.player_demage
	demagetext.text = str(Global1.player_demage)
	anim.stop()
	anim.play("demage_txt")
	if hp <= 0:
		emit_signal("no_hp")
		hpbar.visible = false
	else:
		emit_signal("demage_received")
