extends Area2D

func _on_BurningArea_body_entered(body : Player):
	if body is Player:
		body.hp -= 1
