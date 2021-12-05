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

![Image of the creating tiles under the Player instance](Ch%2004%20-%20Setting%20Collision%20Tiles/pic_creating-collision-tiles.png)

When done, save and replay the Main scene. Now, you can move the Player around.

![Image of the creating tiles under the Player instance](Ch%2004%20-%20Setting%20Collision%20Tiles/pic_testing-player.png)

Now, about that annoying offscreen view...

