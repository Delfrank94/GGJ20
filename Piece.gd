extends RigidBody2D

class_name Piece
var active = true
signal landed
var moveForce = 1800
export var hazard = false

func _ready():
	rotation_degrees = 45 * (randi() % 5)
	apply_impulse(Vector2.ZERO,Vector2.DOWN * moveForce * get_process_delta_time() )

func _physics_process(_delta):
	if active:
		if Input.is_action_just_pressed("ui_up"):
			global_rotation_degrees += 45
		if Input.is_action_pressed("ui_left"):
			apply_impulse(Vector2.ZERO,Vector2.LEFT * moveForce * _delta)
		if Input.is_action_pressed("ui_right"):
			apply_impulse(Vector2.ZERO,Vector2.RIGHT * moveForce * _delta)
		if Input.is_action_pressed("ui_down"):
			apply_impulse(Vector2.ZERO,Vector2.DOWN * moveForce * _delta)
		if position.y >= 1080:
			landed()
			emit_signal("landed", self)
		if Input.is_action_just_pressed("ui_down"):
			SFX.play_fx(SFX.FX.RUSH)

func landed():
	SFX.play_fx(SFX.FX.LAND)
	active = false

func _on_Piece_body_entered(body):
	yield(get_tree().create_timer(.5),"timeout")
	if active:
#			if body.name.find("Ledge") != -1:
#				set_deferred("mode",RigidBody2D.MODE_STATIC)
		landed()
		emit_signal("landed", self)
