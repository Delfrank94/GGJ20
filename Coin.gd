extends Area2D

var points = 0
var active = false

func _ready():
	add_to_group("coins")

func set_active():
	self.active = true

func _on_Coin_body_entered(player : Player):
	if active:
#		player.pocket(self.points)
		self.queue_free()
