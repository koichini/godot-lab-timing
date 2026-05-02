extends Node2D

const BAR_WIDTH := 600.0
const SPEED := 300.0

var _pos := 300.0		# 現在位置
var _direction := 1.0	# 移動方向

@onready var _bar: ProgressBar = $UI/Bar
@onready var _marker: ColorRect = $UI/Marker

func _process(delta: float) -> void:
	_pos += SPEED * _direction * delta

	if _pos >= BAR_WIDTH:
		_pos = BAR_WIDTH
		_direction = -1.0
	elif _pos <= 0.0:
		_pos = 0
		_direction = 1.0

	_bar.value = _pos
	_marker.position.x = _bar.position.x + _pos - _marker.size.x / 2.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.change_scene("res://scenes/TitleScreen.tscn")
