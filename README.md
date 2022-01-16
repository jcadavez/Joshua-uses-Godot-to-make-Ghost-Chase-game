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
var jumpForce : int = 300
var gravity : int = 400

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
if vel.x > 0:
    sprite.flip_h = true 
elif vel.x < 0:
    sprite.flip_h = false
```

To test this, we need to create an environment for the Player.

## Chapter 3 - Creating the Main Scene

Click the '+' tab adjacent to the Player tab of the viewing window. 

The Scene window will display a bunch of root nodes to create. Choose '2D Scene'  

![Image on creating a 2D scene](Ch%2003%20-%20Creating%20the%20Main%20Scene/pic_creating-the-main-scene.png)

Rename the node as 'MainScene' and save it. It'll create the scene MainScene.tscn

![Image on renaming the 2D scene as MainScene](Ch%2003%20-%20Creating%20the%20Main%20Scene/pic_saving-main-scene.png)

Drag the Player.tscn into the MainScene window. The Player instance will be a child under MainScene. 

![Image on dragging the Player instance to MainScene](Ch%2003%20-%20Creating%20the%20Main%20Scene/pic_drag-player-to-main-scene.png)

Now, you'll be able to play the game and test the player. 

Click the Play button at the top right. It'll ask you to select what's the default main scene. Choose the created MainScene. It'll create a new window to play the game.

![Image on selecting default MainScene](Ch%2003%20-%20Creating%20the%20Main%20Scene/pic_playing-main-scene.png)

Or so you thought... the player will fall. Thus, you can't efficiently test out the game. You'll need to create a tilemap so the player can walk and jump around. 

First, right-click under the MainScene node and select the 'Add child node' option. You'll need the 'TileMap' node and rename it as 'DirtTileMap.' 

Once created, select that node to trigger its Inspector Window. Create a tileset by clicking the 'Tile Set' dropdown then 'new Tile Set.' Then, under the Cell section, edit the Size to be `x: 16` and `y: 16`. You might be wondering why these dimensions?

![Image of the DirtTileMap settings](Ch%2003%20-%20Creating%20the%20Main%20Scene/pic_creating-tilemap.png)


That's b/c we'll use our tilemap asset 'tile-ground.png' with 9 types of tiles, each is 16 x 16 pixels. To load it, in Inspector, select the created Tileset to trigger the Tileset bottom panel. Click on the small '+' button aka 'Add Texture(s) to TileSet'. Navigate to the 'Assets' directory then choose the 'tile-ground.png'.

![Image of the DirtTileMap settings](Ch%2003%20-%20Creating%20the%20Main%20Scene/pic_creating-tilemap.png)

Now, we'll have to configure the autotileset settings. Autotileset creates groups of tiles and each tile will be based off its neighboring tiles. 

First, in the TileSet bottom panel, we'll have to select 'Edit' then 'new Autotile'. You'll have to choose the grid icon aka 'Enable snap and show grid (configurable via the Inspector)'. Select part of your tileasset to trigger displaying the Tileset settings in the Inspector window. 

In the 'Autotile Bitmask mode', select '3x3 (minimal).' This allows you to set rules on what tile Autotile will create based on tiles neighboring it from the tile's region below:
- top-left, 	top-center, 	top-right
- mid-left, 	mid-center, 	mid-right,
- bottom-left, 	bottom-center, 	bottom-right

To divide our loaded tilemap asset of 48 x 48 px into nine sections, in the Inspector, we'll have to set the Subtile size to `x: 16` and `y: 16`. We also have to set the Step size to `x: 16` and `y: 16`. Step size will help us properly select which tiles in our loaded tilemap asset to use. So back to the bottom TileSet window, reselect all parts of the loaded tilemap asset.

![Image of the DirtTileMap Autotile settings](Ch%2003%20-%20Creating%20the%20Main%20Scene/pic_setting-autotileset.png)

Remember when I said we have to create rules for what tile to create based on the neighboring tiles? To do so, in the bottom TileSet window, select 'Bitmask' and select the tile sections as shown below in the tilemap asset. Those red sections indicate that this tile will be used if it has tiles neighboring it from that direction.

![Image of the DirtTileMap Bitmask settings](Ch%2003%20-%20Creating%20the%20Main%20Scene/pic_setting-bitmask.png)

Save it and reselect the 'DirtTileMap' node in the Scene window to exit the settings. Now, you can create tiles in the Main scene by dragging your cursor. Create some below your Player instance.

However, if you play the Main scene again, you'll notice that the Player will drop through the tiles. 

![Image of the creating tiles under the Player instance](Ch%2003%20-%20Creating%20the%20Main%20Scene/pic_creating-tiles-in-main-scene.png)

That's b/c you need to set up the tileset's collision properties. That'll be in the next section.

Note, you'll also notice that when you play the game, the Player is a little offscreen. But, we'll fix that later.

## Chapter 4 - Setting the Collision Tiles

Collision tiles are tiles which the Player or other  instances can collide with. Note, collision tiles can be set to collide with certain instances such as by defining layers but that's another topic.

In the Scene window, select the 'DirtTileMap' to display the TileMap Inspector. Then, select the TileSet instance in the Tile Set dropdown to display the bottom Tileset window. In the latter window, select the 'tile-ground.png' and then in the display window, select any tile to display all the tileset modes. 

Click on 'Collision mode'. Now, you'll perform the repetitive process below to make all those tiles collidable. 
1. Click a tile in the tilemap asset.
2. Click the 'New Rectangle' icon
3. Reclick that same tile. Notice that it's yellow, that'll indicate that its collidable
4. Repeat the process until all tiles are collidable

![Image of the creating Collision tiles](Ch%2004%20-%20Setting%20Collision%20Tiles/pic_creating-collision-tiles.png)

When done, save and replay the Main scene. Now, you can move the Player around.

![Image of the Testing the Player](Ch%2004%20-%20Setting%20Collision%20Tiles/pic_testing-player.png)

You'll notice that the player motion animation's not working. No worries, we'll get to that later.

Now, about that annoying offscreen view...

## Chapter 5 - Tracking Camera

When we play the game, there's a camera that controls our view of the game, and that is currently static.

But, we want the camera to follow the Player.

Thus, in the Scene window, right-click under the MainScene node and select 'Add a child node' which will be a 'Camera2D' node.

Once created, select that node to display the Camera Inspector. Then, select the 'current' checkbox so we'll actively use that camera.

![Image of the creating the Camera 2D node](Ch%2005%20-%20Tracking%20Camera/pic_create-camera.png)

To define the Camera's behavior, we need to create a script. In the Scene window, right-click the Camera2D node and select 'Attach Script'. Then, click 'Load' to generate the Camera2d.gd script.

Clear the script but leave the below line alone. That line imports the Camera2D node properties.
```
extends Camera2D
```

Below it, add the below line. This will reference the player node to later track it. `get_node` searches for the node via the given path.
```
onready var player = get_node("/root/MainScene/Player")
```

Then, create a `_process` function with following value below. Thus, in every frame, it'll set the camera's x and y position to be the same as the player's.

```
# tracks the player along the X and Y axis
func _process (delta):
	position = player.position
```
A long form version is below. But, to give you an idea how it looks for each axis.
```
# tracks the player along the X and Y axis
func _process (delta):
	position.x = player.position.x
	position.y = player.position.y
```

## Chapter 6 - Create Enemy

No game is complete without enemies! 

Create a new node KinematicBody2D with the below children and save it as Enemy.tscn and rename the node as Enemy. 
1. Animated Sprite
2. CollisionShape2D

![Image of creating the enemy children nodes](Ch%2006%20-%20Create%20Enemy/pic_create-enemy-node-children.png)

We're going to setup the AnimatedSprite similarly as we did with the Player in Section 1 except we'll use 'spritesheet-enemy-1.png'. It should look like below.

![Image of AnimationSprite settings](Ch%2006%20-%20Create%20Enemy/pic_setting-animation-sprite.png)

For the CollisionShape2D, use a CapsuleShape2D and use the settings below.
![Image of CollisionShape2D settings](Ch%2006%20-%20Create%20Enemy/pic_enemy-collision-shape.png)

Now, we want the enemy to respond to gravity and have them move around. Create a script called Enemy.gd to the root node with the below values.
```
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
	
	# applying the velocity 
	vel = move_and_slide(vel, Vector2.UP)
	
	# gravity
	vel.y += gravity * delta
```

Drag the Enemy scene into the MainScene. If you play the MainScene, you'll notice the enemy fall down to the ground and start moving.

Now, we'll create different Enemy nodes. But, we want them to share the same characteristics except different speeds and spritesheets.

To do so, select Scene > New Inherited Scene... Select the Enemy.tscn. Notice that it'll have a new unsaved scene. Save it as Enemy{COLOR}.tscn

![Image of unsaved inherited Enemy scene](Ch%2006%20-%20Create%20Enemy/pic_inherit-enemy.png)

You'll notice that if you load another spritesheet, it'll affect the parent scene (Enemy.tscn). To avoid this, in the newly created scene, select the AnimatedSprite and the wrench icon in the Inspector. Select 'Make sub-resources unique'.

![Image of subresources unique option](Ch%2006%20-%20Create%20Enemy/pic_unique-sub-resources.png)

Create a few more enemy nodes with the same above steps but with different names, spritesheets, speeds, and distances. Remove the existing Enemy.tscn scene. Then, add one of each to the MainScene for testing. Don't forget to rename the KinematicBody2D node as well.
1. EnemyRed - 'spritesheet-enemy-1.png'
2. EnemyBlue - 'spritesheet-enemy-2.png'
3. EnemyGreen - 'spritesheet-enemy-3.png'

Also, you might want to expand your DirtTileMap b/c we need space to add the enemies.

![Image of multiple enemies](Ch%2006%20-%20Create%20Enemy/pic_create-more-enemies.png)

You can set them to different speeds too in the Inspector. Replay the MainScene, all enemies will start moving. But, when you touch them, you won't get hurt. Time to make it risqué...

## Chapter 7 - Enemy Collisions

We need to detect enemy collisions. To do so, we need to modify the Player.gd script.

Under the `move_and_slide()`, add this code snippet below
```
# iterate through all objects that slide against the player
for i in get_slide_count():
	var collision = get_slide_collision(i)
	if "Enemy" in collision.collider.name:
		print("I collided with ", i, ": ", collision.collider.name)
```

When you play the scene, it'll log whenever the Player collides with another object. 

![Image of logging collisions](Ch%2007%20-%20Enemy%20Collisions/pic_log-enemy-collision.png)

Now, we want to restart the game if the Player collides with the enemies.

Replace the `print()` with `die()` like below
```
if "Enemy" in collision.collider.name:
	die()
```

And then create the function below. Then, replay the game. It now works!
```
func die():
	get_tree().reload_current_scene()
```

## Chapter 8 - Collecting Coins 

The Player needs an objective other than dodging enemies. So, let's add coins!

In the script Player.gd, create the below function `collect_coin()`
```
# called when we run into a coin
func collect_coin (value):
    score += value
```

Let's create a new scene with the root node Area2D. Add a CollisionShape2D with a circle shape. Then, drag and center the asset 'sprite-coin.png'

![Image of coin settings](Ch%2008%20-%20Coin%20Signals/pic_coin-settings.png)

Now, we need to create a signal when the player collides with the signal. Signals allow the node to send a message that other nodes can listen and respond to.

Select the root Area2D node and in the Inspector, select the Node tab. Double-click on the `body_entered` signal to attach it on the script.

![Image of creating the coin signal](Ch%2008%20-%20Coin%20Signals/pic_coin-body-enters-signal.png)

Add below to the created signal function
```
# called when something collides with us
func _on_Coin_body_entered (body):
    if body.name == "Player":
        body.collect_coin(value)
        queue_free()
```

Save this Coin as a scene Coin.tscn and drag several instances to the Main scene to test it out. The problem is that we don't know what's the score. But, we'll solve that in the next chapter.

The coins are small, so feel free to adjust the CollisionShape2D and sprite size. I made it twice as big.

![Image of testing coins](Ch%2008%20-%20Coin%20Signals/pic_testing-coins.png)

## Chapter 9 Score UI

Create a new scene with the root node as Control (aka User Interface). Rename it as UI and save it as UI.tscn.

![Image of Creating the UI](Ch%2009%20-%20Score%20UI/pic_creating-ui.png)

To create the coin icon, add a child node of type TextureRect. Then, drag the coin sprite asset into the Inspector's Texture field. Also, set the Position to 20, 20.

![Image of Setting the Coin Icon](Ch%2009%20-%20Score%20UI/pic_ui-coin-icon.png)

To create the text, add a child node Label with the below settings:
1. Rename to 'ScoreText'
2. Set the Position to 90, 20
3. Set the Size to 100, 64

![Image of Creating the Label](Ch%2009%20-%20Score%20UI/pic_create-label.png)

We want to create the font. In the Inspector and under Custom Fonts, create a new DynamicFont. Drag from the Assets folder Mostly Ghostly.ttf to the Font Data. Set the font size to 40. In the Font dropdown, save it in the Assets folder as GhostFont.tres. Save changes to the ScoreText.

![Image of creating the font](Ch%2009%20-%20Score%20UI/pic_creating-font.png)

Still in the Inspector, in the Text input box, set a placeholder number. I chose 50. Set the Valign to Center to center the text vertically.

![Image of creating placeholder text](Ch%2009%20-%20Score%20UI/pic_setting-font-text.png)

On second thought, it might be better to make the coin icon bigger. Click the TextureRect node and select the Coin sprite in the Inspector. Then, set the following:
1. Expand is checked on
2. Stretch mode is set to Scale on Expand (Compat)
3. Position is set to 20, 30

![Image of Setting the Coin icon size](Ch%2009%20-%20Score%20UI/pic_ui-coin-size-settings.png)

Before we drag the UI scene into the Main scene, we want to make sure the UI follows the camera. 

So first, add the node CanvasLayer under the MainScene root node. Then, add the UI node under CanvasLayer. Now, play the Main scene. The UI should follow the player.

![Image of testing UI](Ch%2009%20-%20Score%20UI/pic_testing-ui.png)

To update the score, create the script UI.gd with the below snippet.
```
extends Control

# gets the score text node when the game starts
onready var scoreText = get_node("ScoreText")

# initializes score to 0
func _ready():
	scoreText.text = "0"

# sets the score
func set_score_text(score):
	scoreText.text = str(score)
```

In the Player script, create a variable to reference the UI node.
```
onready var ui = get_node("/root/MainScene/CanvasLayer/UI")
```
And in the `collect_coin()` function, add to the bottom below. If you see path warnings, ignore it and play to see if it works (hopefully). 
```
ui.set_score_text(score)
```
When you collect the coins, it should update the score.

![Image of testing Score UI](Ch%2009%20-%20Score%20UI/pic_testing-score-ui.png)

## Chapter 10 Animation State

To play the Player's animation when he moves, add the below code snippet to the Player.gd script's movement inputs

```
# plays "float" animation if it's moving
if vel.x != 0:
	sprite.play("float")
else:
	sprite.stop()
```

We'll perform the same with the Enemy. Add the below code snippet to Enemy.gd script's movement code snippet.
```
# plays "float" animation if it's moving
if vel.x != 0:
	sprite.play("float")
else:
	sprite.stop()
```

Play the game and you can observe their animated movements.

Now, we need to create the Player's death animation.

First, we need to create a death animation similar to how we added it in 'Chapter 1 - Creating the Player'. Confirm the AnimationSprite's default animation is 'float' otherwise it'll look dead on the start (unless you move).

![Image of Player death animation settings](Ch%2010%20-%20Animation%20States/pic_death-animation-settings.png)

Open the player.gd script and the below variable
```
var alive = true
```
Then in the `physics_process` function, add the code under the below conditional
```
func _physics_process(delta):
	# Player moves only if alive
	if alive:
	...
```

Finally, update the `die` function to below
```
func die():
	alive = false
	sprite.play("death")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().reload_current_scene()
```

Replay the game and observe if the death animation plays as expected.

Note: There's a known issue that if you stay still AND the enemy crashes into you, the death doesn't trigger. Perhaps, there's a better way to trigger damage.

## Chapter 11 Start Menu

First, create a Node2D scene called 'MenuScene'.

Add a child CanvasLayer node called 'HUD'. This stands for Heads Up Display.

Add several children nodes under with the following properties
1. Label
	- text: Ghost Chase Game
	- name: Message
	- align: center 
	- layout: HCenter Wide
2. Timer
	- name: MessageTimer
	- One Shot: on selected
	- Wait Time: 3
3. Button 
	- text: Start
	- layout: center
	- margin top: -100 
	- margin bottom: -80
4. Label
	- text: Ready to play?
	- layout: HCenterwide
	- align: center 
	- valign: center

![Image of children nodes](Ch%2011%20-%20Start%20Menu/pic_menu-nodes.png)

Create a GDscript for the MenuScene node and the below code
```
extends Node2D

onready var timer = get_node("HUD/MessageTimer");
var countdownMessage = "Ready to play?"
var countdownFlag = false

func _process(delta):
	if (countdownFlag):
		$HUD/CountdownMessage.text = str(ceil(timer.time_left))

func show_message(text):
	$HUD/Message.text = text 
	$HUD/Message.show()
	$HUD/MessageTimer.start()
```
For the StartButton,create a `pressed()` signal for the MenuScene script. And it should have the below code.
```
func _on_StartButton_pressed():
	show_message("Playing the Ghost game in...")
	countdownFlag = true
	$HUD/StartButton.hide()
	# Wait until the MessageTimer has counted down.
	yield($HUD/MessageTimer, "timeout")
	get_tree().change_scene("res://MainScene.tscn")
``` 

In the Player GD script, replace the `die()` function's `get_tree().reload_current_scene()` with `get_tree().change_scene("res://MenuScene.tscn")`

In the Project Settings, set the MenuScene as default. And play the game.

![Image of project settings main menu scene](Ch%2011%20-%20Start%20Menu/pic_project-settings-main-scene.png)
