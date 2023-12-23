extends CharacterBody2D

	
@export var speed = 300.0
@export var jump_velocity = -400.0
@export var gravity = 30

@onready var animation_player = $AnimationPlayer
@onready var animation_player2 = $AnimationPlayer2
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):	
	if not is_on_floor():
		velocity.y += gravity
	
	if Input.is_action_just_pressed("jump"):	
		velocity.y = jump_velocity
	
	var horizontal_dir = Input.get_axis("left", "right")
	velocity.x = speed * horizontal_dir
	if horizontal_dir != 0:
		if sign(sprite_2d.scale.x) != sign(horizontal_dir):
			sprite_2d.scale.x *= -1
	

	move_and_slide()
	update_animations(horizontal_dir)
	
func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			animation_player.play("idle")
		else:
			animation_player.play("run")
	else:
		if velocity.y < 0:
			animation_player.play("jump")
		elif velocity.y > 0:
			animation_player.play("land")
	if Input.is_action_just_pressed("click"):
		animation_player2.play("chop")
	if Input.is_action_just_released("click"):
		animation_player2.play("idle")
	
#Mogu obrisati, sluzi mi samo da se podsetim da treba normalizovati mozda
func get_input_direction() -> Vector2:
	var input_dir:Vector2 = Vector2.ZERO
	
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir = input_dir.normalized()
	
	return input_dir
