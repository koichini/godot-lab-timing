extends Node

const SAVE_PATH := "user://audio_settings.cfg"

var _bgm_player: AudioStreamPlayer
var _se_player: AudioStreamPlayer

func _ready() -> void:
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "BGM"
	add_child(_bgm_player)

	_se_player = AudioStreamPlayer.new()
	_se_player.bus = "SE"
	add_child(_se_player)

	_load_settings()

func play_bgm(stream: AudioStream, fade_in: float = 0.0) -> void:
	if _bgm_player.stream == stream and _bgm_player.playing:
		return
	_bgm_player.stream = stream
	_bgm_player.play()
	if fade_in > 0.0:
		_bgm_player.volume_db = -80.0
		var tween := create_tween()
		tween.tween_property(_bgm_player, "volume_db", 0.0, fade_in)

func stop_bgm(fade_out: float = 0.0) -> void:
	if fade_out > 0.0:
		var tween := create_tween()
		tween.tween_property(_bgm_player, "volume_db", -80.0, fade_out)
		tween.tween_callback(_bgm_player.stop)
	else:
		_bgm_player.stop()

func play_se(stream: AudioStream) -> void:
	_se_player.stream = stream
	_se_player.play()

func set_bgm_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear_to_db(value))
	_save_settings()

func set_se_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SE"), linear_to_db(value))
	_save_settings()

func get_bgm_volume() -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM")))

func get_se_volume() -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SE")))

func _save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "bgm_volume", get_bgm_volume())
	cfg.set_value("audio", "se_volume", get_se_volume())
	cfg.save(SAVE_PATH)

func _load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	set_bgm_volume(cfg.get_value("audio", "bgm_volume", 1.0))
	set_se_volume(cfg.get_value("audio", "se_volume", 1.0))
