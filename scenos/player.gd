extends CharacterBody2D

signal health_changed(new_health)
	
enum{
	MOVE,
	ATTACK,
	ATTACK1,
	ATTACK2,
	ATTACKMEGA,
	BLOCK,
	DEMAGE,
	DIE,
	SLIDE,
	MENU
}

const SPEED = 150.0
const JUMP_VELOCITY = -400.0


var state = MOVE
var run_speed = 2
var combo = false
var player_poss
var demage_multiplier = 1
var demage_current

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D
@onready var animplayer = $AnimationPlayer
@onready var hpbar = $"../../CanvasLayer/hpbar"

func _ready():
	Signals.connect("enemy_attack", Callable (self, "_on_demage_received"))


func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		ATTACK1:
			attack1_state()
		ATTACK2:
			attack2_state()
		ATTACKMEGA:
	#		attackmega_state()
			pass
		BLOCK:
			block_state()	
		DEMAGE:
			demage_state()
		DIE:
			die_state()
		SLIDE:
			slide_state()
		MENU:
			menu_state()
	
	Global1.player_demage = Global1.basic_demage * demage_multiplier
	
	if not is_on_floor():
		velocity.y += gravity * delta

		if velocity.y >0 :
			animplayer.play("FALL")
			
	move_and_slide()
	
	player_poss = self.position
	Signals.emit_signal("player_position_update",player_poss)
	
func move_state () :
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED* run_speed
		if velocity.y == 0 :
			if run_speed == 1:
				animplayer.play("Walk")
			else:
				animplayer.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 :
			animplayer.play("Idle")
		
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
		$"Attack direction".rotation_degrees = 180
	elif direction == 1: 
		$AnimatedSprite2D.flip_h = false
		$"Attack direction".rotation_degrees = 0
	
	if Input.is_action_pressed("run"):
		run_speed = 1.4
	else:
		run_speed = 1
		
	if Input.is_action_pressed("block"):
		if velocity.x == 0:
			state = BLOCK
		else:
			state = SLIDE
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func block_state ():
	velocity.x = 0
	animplayer.play("block") 
	if Input.is_action_just_released("block"):
		state = MOVE

func slide_state ():
	animplayer.play("slide") 
	await animplayer.animation_finished
	state = MOVE

func attack_state ():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK1
	demage_multiplier = 1
	velocity.x = 1
	animplayer.play("attack") 
	await animplayer.animation_finished
	state = MOVE
 
func attack1_state ():
	if Input.is_action_just_pressed("up") and combo == true:
		state = ATTACK2
	demage_multiplier = 1.4
	velocity.x = 1
	animplayer.play("attack1") 
	await animplayer.animation_finished
	state = MOVE

func attack2_state ():
	#if Input.is_action_just_pressed("attack") and combo == true:
	#	state = ATTACKMEGA
	
	animplayer.play("Super_Attack") 
	demage_multiplier = 2
	await animplayer.animation_finished
	state = MOVE
	
#func attackmega_state ():
	#animplayer.play("Super_Attack") 
	#await animplayer.animation_finished
	#state = MOVE
	
func combo1():
	combo = true
	await animplayer.animation_finished
	combo = false
		
func demage_state ():
	velocity.x=0
	animplayer.play("take_hit")
	await animplayer.animation_finished
	state = MOVE


func _on_demage_received(enemy_demage):
	if state == BLOCK:
		enemy_demage /=2
	elif state == SLIDE:
		enemy_demage = 0
	else:
		state = DEMAGE
	Global1.hp -= enemy_demage
	if Global1.hp <= 0:
		Global1.hp = 0
		state = DIE
	emit_signal("health_changed", Global1.hp)
	
func menu_state():
	get_tree().change_scene_to_file("res://scenos/menu.tscn")
	
func die_state():
	velocity.x = 0
	animplayer.play("die")
	await animplayer.animation_finished
	state = MENU



func _on_hit_box_area_entered(area):
	Signals.emit_signal("player_attack", Global1.player_demage)
