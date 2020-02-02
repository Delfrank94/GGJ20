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
var dropNewPiece = false
var timeout = false
export var creationMargins = Vector2(300,300)
export var mode = "tetris"
export var tetrisTime = 30
export var playerTime = 30
var currentLevelIndex = -1
var currentLevel
onready var UI = $Camera2D/Ui
var lastCheckpoint : Vector2
onready var tw = $Tween

func nextLevel():
	currentLevelIndex+= 1
	currentLevel = $Levels.get_children()[currentLevelIndex]


func _ready():
	lastCheckpoint = $Player.position
	nextLevel()
	randomize()
#	UI.reset(tetrisTime)
	if mode == "player":
		dropNewPiece = false
		$Player.active = true
	var tut = $Camera2D/TetrisTutorial2
	tut.frame = 0
	yield(tut,"animation_finished")
	tw.interpolate_property(tut,"modulate",tut.modulate,Color.transparent,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tw.start()
	UI.reset(tetrisTime)
	dropNewPiece = true
	SFX.play_music()

func _process(_delta):
	if dropNewPiece && !timeout:
		dropNewPiece = false
		var newPiecePosition = Vector2(
			wrapi(randi(),
			$Camera2D/PieceMarginA.global_position.x,
			$Camera2D/PieceMarginB.global_position.x),
			$Camera2D/PieceMarginA.global_position.y-200)
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
	timeout = true
	match mode:
		"tetris":
			if(currentPiece.active):
				yield(currentPiece,"landed")
			$Player.active = true
			get_tree().call_group("coins", "set_active")
			mode = "player"
			var tut2 = $Camera2D/PlayerTutorial
			tut2.visible = true
			tut2.frame = 0
			yield(tut2,"animation_finished")
			tw.interpolate_property(tut2,"modulate",tut2.modulate,Color.transparent,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
			tw.start()
			UI.reset(playerTime)
			
		"player":
			reset()

func clearLevel():
	get_tree().call_group("coins", "set_inactive")
	for p in pieces.get_children():
		p.queue_free()
	UI.reset(tetrisTime)
	$Player.active = false
	currentPiece = null
	dropNewPiece = true
	mode = "tetris"
	timeout = false

func reset():
	$Player.position = lastCheckpoint
	clearLevel()


func _on_Area2D_changeCamera(body, cameraPos):
	if body is Player:
		lastCheckpoint = body.position
		var tw = $Tween
		var cam = $Camera2D
		tw.interpolate_property(cam,"position", cam.position,cameraPos,1,Tween.TRANS_QUAD,Tween.EASE_IN)
		tw.start()
		yield(tw,"tween_completed")
		clearLevel()

func _on_Player_died():
	reset()

func _on_End_area_entered(area):
	$Transition.selectedLevel = 1
	$Transition.changeScene()
