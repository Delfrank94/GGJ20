extends Control

const MAX_AUDIO_PLAYERS = 8
var ONE_AT_TIME : Array = [ FX.RUSH ]

var _audio_players : Array
var _stream_tags : Dictionary
var _audio_player_idx : int = 0

enum FX { COIN, JUMP, LAND, RUSH }

const streams = {
	FX.COIN: preload("res://sound/coin.wav"),
	FX.JUMP: preload("res://sound/jump.wav"),
	FX.LAND: preload("res://sound/land.wav"),
	FX.RUSH: preload("res://sound/rush.wav")
}

func _ready():
	print(8 % 8)
	_audio_players.resize(MAX_AUDIO_PLAYERS)
	for i in range(MAX_AUDIO_PLAYERS):
		_audio_players[i] = AudioStreamPlayer.new()
		add_child(_audio_players[i])

func play_fx(key):
	if streams.has(key) and not(ONE_AT_TIME.has(key) and _is_playing(key)):
		var stream : AudioStreamSample = streams[key]
		_stream_tags[_audio_player_idx] = key
		_audio_players[_audio_player_idx].set_stream(stream)
		_audio_players[_audio_player_idx].play()
		_audio_players[_audio_player_idx].connect("finished", self, "_stream_untag", [_audio_player_idx])
		_audio_player_idx = (_audio_player_idx + 1) % MAX_AUDIO_PLAYERS

func _stream_untag(idx):
	_stream_tags.erase(idx)

func _is_playing(key):
	return _stream_tags.values().has(key)
	
