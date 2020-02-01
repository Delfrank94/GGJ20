extends Control

const MAX_AUDIO_PLAYERS = 8

var _audio_players : Array
var _audio_player_idx : int = 0

enum FX { COIN, JUMP, LAND }

const streams = {
	FX.COIN: preload("res://sound/coin.wav"),
	FX.JUMP: preload("res://sound/jump.wav"),
	FX.LAND: preload("res://sound/land.wav")
}

func _ready():
	print(8 % 8)
	_audio_players.resize(MAX_AUDIO_PLAYERS)
	for i in range(MAX_AUDIO_PLAYERS):
		_audio_players[i] = AudioStreamPlayer.new()
		add_child(_audio_players[i])

func play_fx(key):
	if streams.has(key):
		var stream : AudioStreamSample = streams[key]
		_audio_players[_audio_player_idx].set_stream(stream)
		_audio_players[_audio_player_idx].play()
		_audio_player_idx = (_audio_player_idx + 1) % MAX_AUDIO_PLAYERS
