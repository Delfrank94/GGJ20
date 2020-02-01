extends Area2D

var points = 0
var active = false

func _ready():
	add_to_group("coins")

func set_active():
	self.active = true

func _on_Coin_body_entered(player : Player):
	if player and self.active:
		player.pocket(self.points)
		SFX.play_fx(SFX.FX.COIN)
		self.queue_free()
