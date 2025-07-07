class_name AudioManager
extends Node

enum AudioType {
	SFX,
	MUSIC,
	UI,
	AMBIENT
}

@export var sfx_bus: String = "SFX"
@export var music_bus: String = "Music"
@export var ui_bus: String = "UI"
@export var ambient_bus: String = "Ambient"

@onready var sfx_players: Node = $SFXPlayers
@onready var music_players: Node = $MusicPlayers
@onready var ui_players: Node = $UIPlayers
@onready var ambient_players: Node = $AmbientPlayers

var master_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 1.0
var ui_volume: float = 1.0
var ambient_volume: float = 1.0


func _ready() -> void:
	ServiceLocator.register_audio_manager(self)


func play_sfx(audio_stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> AudioStreamPlayer:
	return _play_audio(audio_stream, sfx_players, sfx_volume, volume_db, pitch_scale)


func play_music(audio_stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0, fade_in: float = 0.0) -> AudioStreamPlayer:
	stop_all_music(fade_in)
	var player = _play_audio(audio_stream, music_players, music_volume, volume_db, pitch_scale)
	
	# 淡入效果
	if fade_in > 0.0:
		player.volume_db = -80.0 # 开始时静音
		var tween = create_tween()
		tween.tween_property(player, "volume_db", volume_db, fade_in)
	
	return player


func play_ui(audio_stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> AudioStreamPlayer:
	return _play_audio(audio_stream, ui_players, ui_volume, volume_db, pitch_scale)


func play_ambient(audio_stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> AudioStreamPlayer:
	return _play_audio(audio_stream, ambient_players, ambient_volume, volume_db, pitch_scale)


func _play_audio(audio_stream: AudioStream, player_node: Node, type_volume: float,
				volume_db: float, pitch_scale: float) -> AudioStreamPlayer:
	if not audio_stream or not player_node:
		return null
	
	var player = _get_available_player(player_node)
	
	player.stream = audio_stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	
	player.volume_db += linear_to_db(master_volume * type_volume)
	
	player.play()
	
	return player


func _get_available_player(player_node: Node) -> AudioStreamPlayer:
	for child in player_node.get_children():
		if child is AudioStreamPlayer and not child.playing:
			return child
	
	# 如果没有空闲播放器，创建一个新的
	var new_player = AudioStreamPlayer.new()
	player_node.add_child(new_player)
	return new_player


func stop_all_audio(fade_out: float = 0.0) -> void:
	stop_all_sfx(fade_out)
	stop_all_music(fade_out)
	stop_all_ui(fade_out)
	stop_all_ambient(fade_out)


func stop_all_sfx(fade_out: float = 0.0) -> void:
	_stop_players(sfx_players, fade_out)


func stop_all_music(fade_out: float = 0.0) -> void:
	_stop_players(music_players, fade_out)


func stop_all_ui(fade_out: float = 0.0) -> void:
	_stop_players(ui_players, fade_out)


func stop_all_ambient(fade_out: float = 0.0) -> void:
	_stop_players(ambient_players, fade_out)


func _stop_players(player_node: Node, fade_out: float = 0.0) -> void:
	for child in player_node.get_children():
		if child is AudioStreamPlayer and child.playing:
			if fade_out > 0.0:
				# 创建淡出效果
				var tween = create_tween()
				tween.tween_property(child, "volume_db", -80.0, fade_out)
				tween.tween_callback(child.stop)
			else:
				child.stop()


func set_master_volume(volume: float) -> void:
	master_volume = clamp(volume, 0.0, 1.0)


func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)


func set_music_volume(volume: float) -> void:
	music_volume = clamp(volume, 0.0, 1.0)


func set_ui_volume(volume: float) -> void:
	ui_volume = clamp(volume, 0.0, 1.0)


func set_ambient_volume(volume: float) -> void:
	ambient_volume = clamp(volume, 0.0, 1.0)