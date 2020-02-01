extends RichTextLabel

export var timerPath : NodePath
onready var countdownTimer :Timer = get_node(timerPath)
export var time: int

func _ready():
	countdownTimer.start(time)

func _process(_delta):
	var minutes = int(countdownTimer.time_left) / 60
	var seconds = int(countdownTimer.time_left) % 60
#	var seconds = int(countdownTimer.time_left) % 60
#	var minutes = int(countdownTimer.time_left) / 60 % 60
	var strRemaining = "%02d : %02d" % [minutes,seconds]
	text = strRemaining
#	$Roundbar.setPorcentage(countdownTimer.time_left,endTimeSec - startTimeSec)
