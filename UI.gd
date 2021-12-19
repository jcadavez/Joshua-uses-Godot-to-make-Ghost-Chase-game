extends Control

# gets the score text node when the game starts
onready var scoreText = get_node("ScoreText")

# initializes score to 0
func _ready():
	scoreText.text = "0"

# sets the score
func set_score_text(score):
	scoreText.text = str(score)
