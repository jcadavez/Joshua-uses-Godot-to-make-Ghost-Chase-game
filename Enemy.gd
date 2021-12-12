extends KinematicBody2D

# physics
export var speed : int = 100
export var moveDist : int = 100
var gravity : int = 800

onready var startX : float = position.x 
onready var targetX : float = position.x + moveDist
var vel : Vector2 = Vector2()

# components
onready var sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called 60 times a second to define Player's physics calculations
func _physics_process(delta):
	# applying the velocity 
	vel = move_and_slide(vel, Vector2.UP)
	
	# gravity
	vel.y += gravity * delta
	
	# move to the "targetX" position 
	position.x = move_to(position.x, targetX, speed * delta)

	# if we're at our target, move in the other direction
	if position.x == targetX:
		# if you start at the beginning, move to the finish
		if targetX == startX:
			targetX = position.x + moveDist
		# if you reach the end, return to start
		else:
			targetX = startX

# moves "current" towards "to" in an increment of "step"
func move_to(current, to, step):
	# are we moving positive?
	if current < to:
		current += step
		# ensures they don't overstep the target
		if current > to:
			current = to
			
	# are we moving negative?
	else:
		current -= step
		# ensures they don't overstep the target
		if current < to:
			current = to 
			
	return current
