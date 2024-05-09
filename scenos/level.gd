extends Node2D
@onready var light=$Sviesa/DirectionalLight2D
@onready var pointlight = $Sviesa/PointLight2D
@onready var day_text = $CanvasLayer/daytext
@onready var animplayer = $CanvasLayer/AnimationPlayer
@onready var hpbar = $CanvasLayer/hpbar
@onready var foodbar = $CanvasLayer/foodbar
@onready var player = $Player2/Player


enum{
	MORNING,
	DAY,
	EVENING,
	NIGHT
}


var state = MORNING




func _ready():
	Global1.gold = 0
	Global1.basic_demage = 10 
	Global1.skull = 0 
	Global1.hp = Global1.max_hp 
	hpbar.max_value = Global1.max_hp
	hpbar.value = hpbar.max_value
	light.enabled = true
	foodbar.max_value = 100
	
	foodbar.value = foodbar.max_value
	
	set_day_text()
	day_text_fade()

	$CanvasLayer/shop11.visible = false
	$CanvasLayer/shopmyg.visible = false

func _process(_delta):
	match state:
		MORNING:
			morning_state()
	match state:
		EVENING:
			evening_state()

func morning_state():
	foodbar.value = Global1.food
	var tween = get_tree().create_tween()
	tween.tween_property(light,"energy", 0.2, 20)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointlight,"energy", 0, 20)
func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light,"energy", 0.95, 20)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointlight,"energy", 1.5, 20)

func _on_day_night_timeout():
	if state < 3:
		state += 1
	else:
		state = MORNING
		Global1.dienu_kiek  += 1
		set_day_text()
		day_text_fade()
		Global1.food = Global1.food - 20
	Signals.emit_signal("day_time",state)

func day_text_fade():
	animplayer.play("day_text_fade")
	await get_tree().create_timer(3).timeout
	animplayer.play("day_text_fade2")

func set_day_text():
	day_text.text = "DAY " + str(Global1.dienu_kiek)




func dienu_kiek10():
	pass


func _on_checkhp_timeout():
	
	hpbar.max_value = Global1.max_hp
	hpbar.value = Global1.hp



func _on_shop_area_entered(_area):
	$CanvasLayer/shopmyg.visible = true




func _on_shop_area_exited(_area):
	$CanvasLayer/shopmyg.visible = false
