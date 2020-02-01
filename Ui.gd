extends Control

export var timerPath : NodePath
onready var countdownTimer :Timer = get_node(timerPath)
export var time: int = 1

func _ready():
	countdownTimer.start(time)

func _process(_delta):
	$RoundBar.porcentage = 100
	var minutes = int(countdownTimer.time_left) / 60
	var seconds = int(countdownTimer.time_left) % 60
	var strRemaining = "%02d : %02d" % [minutes,seconds]
	$TimeLabel.text = strRemaining
	$RoundBar.setPorcentage(countdownTimer.time_left,time,false)
