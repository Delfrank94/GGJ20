extends Area2D

var points = 0
var active = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("coins")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_active():
	self.active = true


func _on_Coin_body_entered(player : Player):
	if active:
		player.pocket(self.points)
		self.queue_free()
