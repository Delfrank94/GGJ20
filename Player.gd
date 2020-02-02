extends KinematicBody2D

class_name Player

export var _dashSpeed = 350
export var gravity = 20
export var maxSpeed = 200
export var speed = Vector2(50,550)
onready var sprite : AnimatedSprite = $player

var active = false
var _canJump = true
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var jumpCount = 0
var facing = 1
var hp = 4 setget setHp
var onGround = false
var coins = 0 setget setCoins

signal died
signal coin

func setHp(value):
	hp = value
	$AnimationPlayer.play("hurt")
	if hp <= 0:
		emit_signal("died")
		queue_free()

func setCoins(value):
	coins = value
	emit_signal("coin",coins)
	
func _physics_process(_delta):
	if active:
		direction = getDirection(direction)
		velocity = getVelocity(direction,velocity)
	else:
		velocity = Vector2(0,0)
	move_and_slide(velocity,Vector2.UP,
				false, 4, PI/6, false)
	checkGround()
	if position.y >= 1150:
		get_tree().reload_current_scene()
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
			sprite.play("land")
	else:
		if onGround == true:
			onGround = false

func getHorizontalVelocity(_direction):
	speed.x = 600
	return _direction * speed.x

func getVerticalVelocity(_velocity):
	var out = _velocity
	if(!is_on_floor()):
		out.y += gravity
	if Input.is_action_just_pressed("ui_up"):
		if jumpCount < 1:
			SFX.play_fx(SFX.FX.JUMP)
			jumpCount += 1
			out.y = -speed.y
			onGround = false
	return out

func animate():
	sprite.flip_h = facing != 1
	if get_parent().mode == "tetris":
		if sprite.animation != "casting":
					sprite.play("casting")
	else:
		if is_on_floor():
			if sprite.animation != "hurt":
				if abs(velocity.x) <= 0 || is_on_wall():
					if sprite.animation != "idle":
						sprite.play("idle")
				else:
					if sprite.animation != "run":
						sprite.play("run")
		else:
			if (velocity.y >= 0 ):
				if sprite.animation != "fall":
					sprite.play("fall")
			else:
				if sprite.animation != "jump":
					sprite.play("jump")

func _on_Area2D_body_entered(body: Piece):
	if body is Piece:
		if body.hazard && !$AnimationPlayer.current_animation == "hurt":
			self.hp -= 1
