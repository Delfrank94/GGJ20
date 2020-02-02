extends Node2D

export onready var pieceScenes = [
						load("res://Pieces/BoxPiece.tscn"),
						load("res://Pieces/IPiece.tscn"),
						load("res://Pieces/L2Piece.tscn"),
						load("res://Pieces/LPiece.tscn"),
						load("res://Pieces/SPiece.tscn"),
						load("res://Pieces/S2Piece.tscn"),
						load("res://Pieces/TPiece.tscn"),
						load("res://Pieces/LavaPiece.tscn"),
						load("res://Pieces/BarrelPiece.tscn"),
						load("res://Pieces/SpikePiece.tscn")]
onready var pieces = $Pieces
var currentPiece
var paying
var dropNewPiece = true
var timeout = false
export var creationMargins = Vector2(300,300)
export var mode = "tetris"
export var tetrisTime = 30
export var playerTime = 30
var currentLevelIndex = -1
var currentLevel
onready var UI = $Camera2D/Ui

func nextLevel():
	currentLevelIndex+= 1
	currentLevel = $Levels.get_children()[currentLevelIndex]


func _ready():
	nextLevel()
	randomize()
	UI.reset(tetrisTime)
	if mode == "player":
		dropNewPiece = false
		$Player.active = true

func _process(_delta):
	if dropNewPiece && !timeout:
		dropNewPiece = false
		var newPiecePosition = Vector2(
			wrapi(randi(),
			$Camera2D/PieceMarginA.global_position.x,
			$Camera2D/PieceMarginB.global_position.x),
			 -30)
		pieceScenes.shuffle()
		var nextPiece = pieceScenes[wrapi(randi(),0,pieceScenes.size())]
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
	match mode:
		"tetris":
			timeout = true
			if(currentPiece.active):
				yield(currentPiece,"landed")
			$Player.active = true
			get_tree().call_group("coins", "set_active")
			mode = "player"
			UI.reset(playerTime)
		"player":
			#gameoverr
			yield(get_tree().create_timer(1),"timeout")
			get_tree().reload_current_scene()

func clearLevel():
	get_tree().call_group("coins", "set_inactive")
	for p in pieces.get_children():
		p.queue_free()
	UI.reset(tetrisTime)
	$Player.active = false
	dropNewPiece = true
	mode = "tetris"

func _on_Area2D_changeCamera(body, cameraPos):
	if body is Player:
		var tw = $Tween
		var cam = $Camera2D
		clearLevel()
		tw.interpolate_property(cam,"position", cam.position,cameraPos,1,Tween.TRANS_QUAD,Tween.EASE_IN)
		tw.start()
