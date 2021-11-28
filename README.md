# Joshua uses Godot to make Ghost Chase game

See Wiki on how to follow to recreate the game.

## Assets
Used fonts from [1001 Free Fonts](https://www.1001freefonts.com/mostly-ghostly.font)

Used the song "Pixelated Autumn Leaves" by *Jeremy Blake* from Youtube Audio Library.


## Chapter 0 - Creating the Project

Download and open Godot by following the instructions [here](https://godotengine.org/download)

Initialize a new project by either:
1. Cloning this repo's project
2. Creating a new one from scratch (and downloading this repo's Assets in a zip file)

![Image of how to initializing the project](Ch%2000%20-%20Creating%20the%20Project/pic_creating-the-project.png)

If (1), select 'New Project' in the side bar menu. Then, select 'OpenGL ES 3.0'. Next, choose an empty folder to host the project and give it a title. 

Finally, select 'Create & Edit.' It'll create the project. You'll want to add the 'Assets' folder under the 'res://' in the FileSystem.

![Image of how to create a new project](Ch%2000%20-%20Creating%20the%20Project/pic_creating-new-project.png)

Else if (2), select you can run git clone to download this project. There are instructions on Google or Bing. But, here's a [reference](https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-clone).

![Image of how to download the project](Ch%2000%20-%20Creating%20the%20Project/pic_git-clone-project.png)

## Chapter 1 - Creating the Player

Start by creating a player with a KinematicBody2D node ([details why here](https://docs.godotengine.org/en/stable/classes/class_kinematicbody2d.html)). Create it by selecting 'Other Node' and searching for 'KinematicBody2D'. Then, select 'Create'

Rename the node to 'Player'

![Image on creating the Player node](Ch%2001%20-%20Creating%20Player/pic_player-kinematic-node.png)

Save the Player node as a Player scene in the root folder. It'll show as 'Player.tscn' 

We're going to add nodes under the 'Player' node as children. This will give the 'Player' node more properties ([node docs](https://docs.godotengine.org/en/stable/getting_started/step_by_step/scenes_and_nodes.html#nodes))

Right-click the 'Player' node and create below:
- CollisionShape2D
- AnimatedSprite

![Image on creating children under Player node](Ch%2001%20-%20Creating%20Player/pic_adding-children-to-player.png)

It's better to put them in the specific order above b/c it'll be easier to create the collision shape.

Select the 'AnimatedSprite' node and in the Inspector, next to Frames, click 'Create New SpriteFrames.' 

This will create an empty instance of SpriteFrames. Click the created SpriteFrames and it will open the SpriteFrames tab at the bottom of the screen

![Image on creating SpriteFrames](Ch%2001%20-%20Creating%20Player/pic_creating-spriteframes.png)

Under Animation Frames, select 'Add Frames from a sprite sheet.' under the Assets folder. 

Now, browse to find and open the spritesheet 'spritesheet-player.png'. 

![Image on selecting spritesheet](Ch%2001%20-%20Creating%20Player/pic_choosing-spriteframes.png)

Godot will open a new window titled 'Select Frames.' Check that its properties are below:
- horizontal: 3
- vertical: 1
Choose the first two frames and then click the button 'Add 2 Frame(s)'

![Image on selecting animation frames](Ch%2001%20-%20Creating%20Player/pic_selecting-animation-frames.png)

To create the collision shape, select the 'CollisionShape2D' node. In the Inspector, under the 'Shape' dropdown, select 'CapsuleShape2D'.

![Image on creating the collision shape](Ch%2001%20-%20Creating%20Player/pic_selecting-animation-frames.png)

Select the created 'CapsuleShape2D' to set the following properties below:
- Radius: 10
- Height: 10

![Image on setting the collision shape size](Ch%2001%20-%20Creating%20Player/pic_setting-capsule-size.png)

Save the Player scene to keep all changes.

## Chapter 2 - Scripting the Player 

Select the Player node and click the Script icon to create a script for it. Save it as Player.gd.

![Image on creating the script](Ch%2002%20-%20Scripting%20the%20Player/pic_creating-the-player-script.png)

Add the code snippet below. 

```
# stats
var score : int = 0

# physics
var speed : int = 200
var jumpForce : int = 600
var gravity : int = 800

var vel : Vector2 = Vector2()
var grounded : bool = false
```

Vector2 defines an x and y value which will later be used to define the player's position and velocity. 

The other values will define the player's physics.

Now, add the code snippet below. This will locate the AnimatedSprite node.

```
# components
onready var sprite = $AnimatedSprite
```

To prepare the controls, you need to set the Input Map. 

To do so, in the Godot Menu bar, select 'Project' and then, 'Project Settings.'

It'll open the Project Settings window. Select the Input Map tab. 

You can create the actions below by inputting them in the 'Action' input field. And then, set the keys by clicking the '+' button for each.
- move_left - with left arrow key
- move_right - with right arrow key
- jump - with up arrow key

![Image on setting inputs](Ch%2002%20-%20Scripting%20the%20Player/pic_setting-input-map.png)

In the Player.gd script, add below to set the player's horizontal velocity
```
# Called 60 times a second to define Player's physics calculations
func _physics_process(delta):
	# reset the horizontal velocity
	vel.x = 0
	
	# movement inputs 
	if Input.is_action_pressed("move_left"):
		vel.x -= speed 
	if Input.is_action_pressed("move_right"):
		vel.x += speed
```

Add the below code snippet to the _physics_process method. Thus, if it collides with another body, it'll slide the body instead of stop immediately. The second parameter is the ground normal vector, or which direction the ground pushes against objects on it.
```
# applying the velocity 
	vel = move_and_slide(vel, Vector2.UP)
```

To check how it handles gravity and when it can jump, add the below code.

```
# gravity
vel.y += gravity * delta

# jump input
if Input.is_action_pressed("jump") and is_on_floor():
    vel.y -= jumpForce
```

Add the below snippet to flip the script depending on the Player's direction

```
# sprite direction
if vel.x < 0:
    sprite.flip_h = true 
elif vel.x > 0:
    sprite.flip_h = false
```

To test this, we need to create an environment for the Player.
