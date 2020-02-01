tool
extends Control
class_name RoundBar

export var MIN_ANGLE = 0
export var MAX_ANGLE = 360

const POINT_COUNT = 900

export var porcentage: float
export var lowColor : Color
export var fullColor : Color
export var size = 50
export var width = 37
var barColor : Color = lowColor
var tw : Tween

var currentAngle = MIN_ANGLE
var _lastValue = 0

export var demo = false
var complete = false

func _ready() -> void:

	tw = Tween.new()
	add_child(tw)

func drawRoundMeter(_size, _width, current, color):
	draw_arc(Vector2(0,0), _size, deg2rad(MAX_ANGLE), current, POINT_COUNT, color, _width, true)

func _draw() -> void:
	drawRoundMeter(size, width, currentAngle, barColor)

func _process(_delta: float) -> void:
	#This mantains the proportions
#	width = size - 0
	
	#animates the bar for testing
	if demo:
		if porcentage >= 100:
			complete = true
		if porcentage <= 0:
			complete = false
		if !complete:
			self.porcentage +=1
		else:
			self.porcentage -=1
	
	#converts the porcentage to angle values
	porcentage = clamp(porcentage,0,100)
#	var value = ((MIN_ANGLE * -1) + MAX_ANGLE) / 100
#	currentAngle = MAX_ANGLE - (porcentage * value)
	
	currentAngle = (((porcentage+100) * 2 * PI) /100)
	

	#Changes the color depending on the porcentage
	barColor = lerp(lowColor,fullColor,porcentage/100)
	
	#Redraws the bar
	if porcentage != _lastValue:
		update()
	_lastValue = porcentage

func setPorcentage(value, maxValue, interpolate = true):
	var newPorcentage = (value * 100 / maxValue)
	if interpolate:
		tw.interpolate_property(self, "porcentage",porcentage,newPorcentage,0.5,Tween.TRANS_BOUNCE,Tween.EASE_IN)
		tw.start()
	else:
		porcentage = newPorcentage
	yield(tw,"tween_completed")
#	return

