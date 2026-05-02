extends Node2D

const BAR_WIDTH := 600.0
const SPEED := 300.0
const CENTER := BAR_WIDTH / 2.0
const PERFECT_RANGE := 60.0
const GOOD_RANGE := 120.0

var _pos := 300.0		# 現在位置
var _direction := 1.0	# 移動方向

@onready var _bar: ProgressBar = $UI/Bar
@onready var _marker: ColorRect = $UI/Marker
@onready var _judge_label: Label = $UI/JudgeLabel

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
	if event.is_action_just_pressed("ui_accept"):
		_judge()

func _judge() -> void:
	var dist := absf(_pos - CENTER)
	if dist <= PERFECT_RANGE:
		_judge_label.text = "PERFECT!"
		_judge_label.modulate = Color.GREEN
	elif dist <= GOOD_RANGE:
		_judge_label.text = "GOOD!"
		_judge_label.modulate = Color.YELLOW
	else:
		_judge_label.text = "MISS..."
		_judge_label.modulate = Color.RED
