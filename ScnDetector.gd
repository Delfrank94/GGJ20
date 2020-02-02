extends Area2D

export var nextLevelCameraPos : NodePath
signal changeCamera

func _on_Area2D_body_entered(body):
	var cameraPos = get_node(nextLevelCameraPos).global_position
	emit_signal("changeCamera",body,cameraPos)
