extends Piece

func _on_Area2D_body_entered(body):
	._on_Area2D_body_entered(body)
	if body != self && body is Player:
		body.hp -= 1
