extends Camera2D

onready var player = get_node("/root/MainScene/Player")

# tracks the player along the X and Y axis
func _process (delta):
	position = player.position
