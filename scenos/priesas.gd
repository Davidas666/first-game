extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 100
var chase = false
var alive = true
@onready var anim = $AnimatedSprite2D
func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $"../Player2/Player"
	var direction = (player.position - self.position).normalized()
	if alive == true:
		if chase == true:
			velocity.x = direction.x * speed
			anim.play("run")
		else:
			velocity.x = 0
			anim.play("Idle")
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
			
		move_and_slide()

		
func _on_detector_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_detector_body_exited(body):
	if body.name == "Player":
		chase = false



func _on_dead_body_entered(body):
	if body.name == "Player":
		death()

func death():
	alive = false
	anim.play("dead")
	await	anim.animation_finished
	queue_free()


func _on_dead_2_body_entered(body):
	if body.name == "Player":
		if alive == true:
			body.hp -=40
		death()
