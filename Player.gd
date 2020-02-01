extends KinematicBody2D

class_name Player

export var _dashSpeed = 350
export var gravity = 20
export var maxSpeed = 200
export var speed = Vector2(50,550)
var active = false

var _canJump = true

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var jumpCount = 0
onready var animator = $AnimationPlayer
var facing = 1
var hp = 4 setget setHp
var onGround = false
onready var sprite = $player

signal died

func setHp(value):
	hp = value
	$PlayerTag.reduceLives(hp)
	animator.play("hurt")
	if hp <= 0:
		yield(get_tree().create_timer(1.2),"timeout")
		emit_signal("died",self)


func _physics_process(_delta):
	if active:
		direction = getDirection(direction)
		velocity = getVelocity(direction,velocity)
		velocity = move_and_slide(velocity,Vector2.UP)
		checkGround()
	animate()

func getDirection(out):
	out.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if out.x != 0:
		facing = out.x
	return out

func getVelocity(_direction, _velocity):
	var out = _velocity
	out.x = getHorizontalVelocity(_direction.x)
	out = getVerticalVelocity(out)
	if Input.is_action_just_pressed("p1_dash"):
		out.x += facing * 1600 #dashSpeed
	return out

func checkGround():
	if is_on_floor():
		if onGround == false:
			onGround = true
			jumpCount = 0
	else:
		if onGround == true:
			onGround = false

func getHorizontalVelocity(_direction):
	speed.x = 600
	return _direction * speed.x

func getVerticalVelocity(_velocity):
	var out = _velocity
	out.y += gravity
	if Input.is_action_just_pressed("ui_up"):
		if jumpCount < 2:
			jumpCount += 1
			out.y = -speed.y
			onGround = false
	return out

func animate():
	$player.flip_h = facing != 1
#	if is_on_floor():
#		if animator.current_animation != "hurt":
#			if abs(velocity.x) <= 30 || is_on_wall():
#				if animator.current_animation != "idle":
#					animator.play("idle")
#			else:
#				if animator.current_animation != "run":
#					animator.play("run")
#	else:
#		if animator.current_animation != "jump":
#			animator.play("jump")
