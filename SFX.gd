extends Control

var _player : AudioStreamPlayer

enum FX { COIN, JUMP, LAND }

const streams = {
	FX.COIN: preload("res://sound/coin.wav"),
	FX.JUMP: preload("res://sound/jump.wav"),
	FX.LAND: preload("res://sound/land.wav")
}

func _ready():
	_player = AudioStreamPlayer.new()
	add_child(_player)

func play_fx(key):
	if streams.has(key):
		print("has key")
		var stream : AudioStreamSample = streams[key]
		_player.set_stream(stream)
		_player.play()
	else:
		print("doesn't have it")
