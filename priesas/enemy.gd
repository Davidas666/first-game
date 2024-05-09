extends CharacterBody2D
class_name enemy
enum{
	IDLE,
	ATTACK,
	CHASE,
	DEMAGE,
	DEATH,
	RECOVER
}
var state: int =0:
	set(value):
		state=value
		match state:
			IDLE:
				idle_state()
		match state:
			ATTACK:
				attack_state()
		match state:
			CHASE:
				chase_state()
		match state:
			DEMAGE:
				demage_state()
		match state:
			DEATH:
				death_state()
		match state:
			RECOVER:
				recover_state()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player = Vector2.ZERO
var direction = Vector2.ZERO
var player_demage 
var demage = 20
var move_speed = 150

var alive = true
@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
func _ready():
	Signals.connect("player_position_update", Callable (self, "_on_player_position_update"))
	state = CHASE

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if state == CHASE:
		chase_state()
		
	move_and_slide()
	
func on_damage_received(damage):
	var player_demage = damage

func _on_player_position_update(player_poss):
	player = player_poss
	

func _on_attack_range_body_entered(body):
	state = ATTACK

func idle_state():
	anim.play("Idle")
	state = CHASE
	
func attack_state():
	velocity.x = 0
	anim.play("attack")
	await anim.animation_finished
	state = RECOVER

func chase_state():
	anim.play("run")
	direction  = (player - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = false
		$AttackDirection.rotation_degrees= 0
	else:
		$AttackDirection.rotation_degrees = 180
		sprite.flip_h = true
	velocity.x = direction.x * move_speed



func demage_state():
	velocity.x = 0
	anim.play("hit")
	await anim.animation_finished
	state = IDLE

func death_state():
	velocity.x = 0
	anim.play("death")
	await anim.animation_finished
	queue_free()
	
	
func recover_state():
	anim.play("recover")
	await anim.animation_finished
	if $AttackDirection/AttackRange.has_overlapping_bodies():
		state = ATTACK
	else:
		state = IDLE





func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", demage)




func _on_timer_timeout():
	move_speed = move_toward(move_speed, randi_range(120,170),100)
