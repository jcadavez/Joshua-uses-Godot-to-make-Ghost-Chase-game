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

func _on_StartButton_pressed():
	show_message("Playing the Ghost game in...")
	countdownFlag = true
	$HUD/StartButton.hide()
	# Wait until the MessageTimer has counted down.
	yield($HUD/MessageTimer, "timeout")
	get_tree().change_scene("res://MainScene.tscn")
