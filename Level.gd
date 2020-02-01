extends Node2D

onready var pieceScene = load("res://BoxPiece.tscn")
onready var pieces = $Pieces
var currentPiece
var paying
var dropNewPiece = true
var timeout = false
export var creationMargins = Vector2(0,0)

func _ready():
	randomize()

func _process(_delta):
	if dropNewPiece && !timeout:
		var newPiecePosition = Vector2(
			wrapi(randi(),
			creationMargins.x,get_viewport_rect().size.x/2 - creationMargins.y),
			 0)
		dropNewPiece = false
		currentPiece = pieceScene.instance()
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
	
