extends Area2D

export var nextLevel = 0
signal changeCamera

func _on_Area2D_body_entered(body):
	emit_signal("changeCamera",nextLevel)
