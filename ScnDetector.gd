extends Area2D

export var nextLevelCameraPos : NodePath
signal changeCamera
var passed = false

func _on_Area2D_body_entered(body):
	if !passed && body is Player:
		passed = true
		var cameraPos = get_node(nextLevelCameraPos).global_position
		emit_signal("changeCamera",body,cameraPos)
