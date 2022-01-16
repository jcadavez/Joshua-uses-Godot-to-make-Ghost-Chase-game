extends KinematicBody2D

# stats
var score : int = 0

# physics
var speed : int = 200
var jumpForce : int = 300
var gravity : int = 400

var vel : Vector2 = Vector2()
var grounded : bool = false
var alive = true

# components
onready var sprite = $AnimatedSprite
onready var ui = get_node("/root/MainScene/CanvasLayer/UI");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called 60 times a second to define Player's physics calculations
func _physics_process(delta):
	# Player moves only if alive
	if alive:
		# reset the horizontal velocity
		vel.x = 0
		
		# movement inputs 
		if Input.is_action_pressed("move_left"):
			vel.x -= speed 
		if Input.is_action_pressed("move_right"):
			vel.x += speed
			
		# plays "float" animation if it's moving
		if vel.x != 0:
			sprite.play("float")
		else:
			sprite.stop()
			
		# applying the velocity 
		vel = move_and_slide(vel, Vector2.UP)
		# iterate through all objects that slide against the player
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if "Enemy" in collision.collider.name:
				die()
		
		# gravity
		vel.y += gravity * delta
		
		# jump input
		if Input.is_action_pressed("jump") and is_on_floor():
			vel.y -= jumpForce
			
		# sprite direction
		if vel.x > 0:
			sprite.flip_h = true 
		elif vel.x < 0:
			sprite.flip_h = false
		
func die():
	alive = false
	sprite.play("death")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://MenuScene.tscn")
	
# called when we run into a coin
func collect_coin (value):
	score += value
	ui.set_score_text(score)
	
