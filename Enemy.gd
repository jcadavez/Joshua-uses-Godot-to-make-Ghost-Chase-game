extends KinematicBody2D

# physics
export var speed : int = 100
export var moveDist : int = 100
var gravity : int = 800

onready var startX : float = position.x 
onready var targetX : float = position.x + moveDist
var vel : Vector2 = Vector2()

# determines direction of the enemy
var go_right : bool

# components
onready var sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	go_right = true

# Called 60 times a second to define Player's physics calculations
func _physics_process(delta):
	# reset the horizontal velocity
	vel.x = 0
	
	# movement
	if position.x < targetX && go_right == true:
		# flips sprite direction based on movement
		sprite.flip_h = true 
		vel.x += speed
	elif position.x > startX && go_right == false:
		# flips sprite direction based on movement
		sprite.flip_h = false 
		vel.x -= speed
	else:
		go_right = !go_right
	
	# plays "float" animation if it's moving
	if vel.x != 0:
		sprite.play("float")
	else:
		sprite.stop()
	
	# applying the velocity 
	vel = move_and_slide(vel, Vector2.UP)
	
	# gravity
	vel.y += gravity * delta
