extends RigidBody2D

class_name Piece
var active = true
signal landed

func _ready():
	rotation_degrees = wrapi(randi(),-360,360)


export var moveForce = 50
func _physics_process(_delta):
	if active:
		if Input.is_action_pressed("ui_up"):
			apply_torque_impulse(150)
		if Input.is_action_pressed("ui_left"):
			apply_impulse(Vector2.ZERO,Vector2.LEFT * moveForce)
		if Input.is_action_pressed("ui_right"):
			apply_impulse(Vector2.ZERO,Vector2.RIGHT * moveForce)
		if Input.is_action_pressed("ui_down"):
			apply_impulse(Vector2.ZERO,Vector2.DOWN * moveForce)

func landed():
	active = false

func _on_Area2D_body_entered(body):
	if body != self && active:
		#SFX.play_fx(SFX.FX.LAND)
		landed()
		emit_signal("landed", self)
