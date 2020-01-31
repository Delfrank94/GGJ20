extends RigidBody2D

func _physics_process(_delta):
	if Input.is_action_pressed("ui_left"):
		apply_impulse(Vector2.ZERO,Vector2.LEFT)
	if Input.is_action_pressed("ui_right"):
		apply_impulse(Vector2.ZERO,Vector2.RIGHT)
	if Input.is_action_pressed("ui_down"):
		apply_impulse(Vector2.ZERO,Vector2.DOWN)
