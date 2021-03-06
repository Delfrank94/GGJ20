extends Area2D

var active = false
export var offset:Vector2
var defaultPosition 

func _ready():
	defaultPosition = position
	add_to_group("coins")

func _process(delta):
	if active:
		modulate = Color.white
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("idle")
	else:
		modulate = Color(1,1,1,0.3)
		$AnimationPlayer.stop()
	position = defaultPosition + offset
	
func set_active():
	self.active = true

func set_inactive():
	self.active = false

func _on_Coin_body_entered(player : Player):
	if player is Player and active:
		player.coins+= 1
		SFX.play_fx(SFX.FX.COIN)
		self.queue_free()
