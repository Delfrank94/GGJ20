extends Control

const MAX_AUDIO_PLAYERS = 8
var ONE_AT_TIME : Array = [ FX.EXPLODE, FX.LAND, FX.RUSH ]

var _audio_players : Array
var _stream_tags : Dictionary
var _audio_player_idx : int = 0

var _music_player : AudioStreamPlayer
var _music_tracks : Array = [
	preload("res://sound/music00.ogg"),
	preload("res://sound/music01.ogg"),
	preload("res://sound/music02.ogg"),
	preload("res://sound/music03.ogg"),
	preload("res://sound/music04.ogg")
]

enum FX { COIN, JUMP, LAND, RUSH, EXPLODE }

const streams = {
	FX.COIN: preload("res://sound/coin.wav"),
	FX.JUMP: preload("res://sound/jump.wav"),
	FX.LAND: preload("res://sound/land.wav"),
	FX.RUSH: preload("res://sound/rush.wav"),
	FX.EXPLODE: preload("res://sound/explode.wav")
}

func _ready():
	_audio_players.resize(MAX_AUDIO_PLAYERS)
	for i in range(MAX_AUDIO_PLAYERS):
		_audio_players[i] = AudioStreamPlayer.new()
		add_child(_audio_players[i])
	_music_player = AudioStreamPlayer.new()
	add_child(_music_player)

func play_fx(key):
	if streams.has(key) and not(ONE_AT_TIME.has(key) and _is_playing(key)):
		var stream : AudioStreamSample = streams[key]
		_stream_tags[_audio_player_idx] = key
		_audio_players[_audio_player_idx].set_stream(stream)
		_audio_players[_audio_player_idx].play()
		if !_audio_players[_audio_player_idx].is_connected("finished", self, "_stream_untag"):
			_audio_players[_audio_player_idx].connect("finished", self, "_stream_untag", [_audio_player_idx])
		_audio_player_idx = (_audio_player_idx + 1) % MAX_AUDIO_PLAYERS

func play_music():
	_music_tracks.shuffle()
	_music_tracks[0].set_loop(false)
	_music_player.set_stream(_music_tracks[0])
	_music_player.play()
	if !_music_player.is_connected("finished", self, "play_music"):
		_music_player.connect("finished", self, "play_music")

func _stream_untag(idx):
	_stream_tags.erase(idx)

func _is_playing(key):
	return _stream_tags.values().has(key)
	
