extends RigidBody2D
signal landed
var active = false

export var moveForce = 50
func _physics_process(_delta):
	if active:
		if Input.is_action_pressed("ui_left"):
			apply_impulse(Vector2.ZERO,Vector2.LEFT * moveForce)
		if Input.is_action_pressed("ui_right"):
			apply_impulse(Vector2.ZERO,Vector2.RIGHT * moveForce)
		if Input.is_action_pressed("ui_down"):
			apply_impulse(Vector2.ZERO,Vector2.DOWN * moveForce)	