extends Node2D

export onready var pieceScenes = [
						load("res://Pieces/BoxPiece.tscn"),
						load("res://Pieces/IPiece.tscn"),
						load("res://Pieces/L2Piece.tscn"),
						load("res://Pieces/LPiece.tscn"),
						load("res://Pieces/SPiece.tscn"),
						load("res://Pieces/TPiece.tscn")]
onready var pieces = $Pieces
var currentPiece
var paying
var dropNewPiece = true
var timeout = false
export var creationMargins = Vector2(300,300)

func _ready():
	randomize()

func _process(_delta):
	if dropNewPiece && !timeout:
		var newPiecePosition = Vector2(
			wrapi(randi(),
			creationMargins.x,get_viewport_rect().size.x/2 - creationMargins.y),
			 0)
		dropNewPiece = false
		pieceScenes.shuffle()
		var nextPiece = pieceScenes[0]
		currentPiece = nextPiece.instance()
		currentPiece.position = newPiecePosition
		pieces.add_child(currentPiece)
		currentPiece.connect("landed",self,"onPieceLanded")

func onPieceLanded(piece: Piece):
	if piece is Piece:
		if !timeout:
			yield(get_tree().create_timer(.5),"timeout")
			dropNewPiece = true

func _on_Timer_timeout():
	print("TIEMPOOOOO")
	timeout = true
	for piece in pieces.get_children():
		if(piece.active):
			yield(piece,"landed")
		else:
			piece.set_deferred("mode",RigidBody2D.MODE_STATIC)
	$Player.active = true
	get_tree().call_group("coins", "set_active")
	
