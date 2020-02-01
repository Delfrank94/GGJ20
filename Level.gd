extends Node2D

onready var pieceScene = load("res://BoxPiece.tscn")


func _ready():
	var piece = pieceScene.instance()
	piece.position = Vector2(get_viewport_rect().size.x/2, 0)
	add_child(piece)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
