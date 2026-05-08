extends Node2D

const BAR_WIDTH := 600.0
const SPEED := 300.0
const CENTER := BAR_WIDTH / 2.0
const PERFECT_RANGE := 60.0
const GOOD_RANGE := 120.0
const MAX_TRIES := 3

const SE_GREAT: AudioStream = preload("res://assets/audio/great.wav")
const SE_GOOD: AudioStream = preload("res://assets/audio/good.wav")
const SE_BAD: AudioStream = preload("res://assets/audio/bad.wav")

var _pos := 300.0
var _direction := 1.0
var _tries_left := MAX_TRIES
var _is_result := false

@onready var _bar: ProgressBar = $UI/GameUI/Bar
@onready var _marker: ColorRect = $UI/GameUI/Marker
@onready var _judge_label: Label = $UI/GameUI/JudgeLabel
@onready var _count_label: Label = $UI/GameUI/CountLabel
@onready var _game_ui: Control = $UI/GameUI
@onready var _result_ui: Control = $UI/ResultUI
@onready var _score_label: Label = $UI/ResultUI/ScoreLabel

func _ready() -> void:
	GameState.reset()
	_count_label.text = "残り %d 回" % _tries_left

func _process(delta: float) -> void:
	if _is_result:
		return
	_pos += SPEED * _direction * delta
	if _pos >= BAR_WIDTH:
		_pos = BAR_WIDTH
		_direction = -1.0
	elif _pos <= 0.0:
		_pos = 0.0
		_direction = 1.0
	_bar.value = _pos
	_marker.position.x = _bar.position.x + _pos - _marker.size.x / 2.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.change_scene("res://scenes/TitleScreen.tscn")
		return
	if not _is_result and event.is_action_pressed("ui_accept"):
		_judge()

func _judge() -> void:
	var dist := absf(_pos - CENTER)
	var points := 0
	if dist <= PERFECT_RANGE:
		_judge_label.text = "PERFECT!"
		_judge_label.modulate = Color.GREEN
		points = 100
		AudioManager.play_se(SE_GREAT)
	elif dist <= GOOD_RANGE:
		_judge_label.text = "GOOD"
		_judge_label.modulate = Color.YELLOW
		points = 50
		AudioManager.play_se(SE_GOOD)
	else:
		_judge_label.text = "MISS..."
		_judge_label.modulate = Color.RED
		AudioManager.play_se(SE_BAD)

	GameState.score += points
	_tries_left -= 1
	_count_label.text = "残り %d 回" % _tries_left

	if _tries_left <= 0:
		_show_result()

func _show_result() -> void:
	_is_result = true
	_game_ui.visible = false
	_result_ui.visible = true
	_score_label.text = "スコア: %d / %d" % [GameState.score, MAX_TRIES * 100]

func _on_back_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/TitleScreen.tscn")
