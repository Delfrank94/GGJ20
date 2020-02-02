extends Control

export var timerPath : NodePath
onready var countdownTimer :Timer = get_node(timerPath)
onready var maxTime = countdownTimer.time_left
func _process(_delta):
	var minutes = int(countdownTimer.time_left) / 60
	var seconds = int(countdownTimer.time_left) % 60
	var strRemaining = "%02d : %02d" % [minutes,seconds]
	$TimeLabel.text = strRemaining
	$RoundBar.setPorcentage(countdownTimer.time_left,maxTime,false)

func reset(time):
	maxTime = time
	countdownTimer.start(time)
	$RoundBar.setPorcentage(countdownTimer.time_left,maxTime)
