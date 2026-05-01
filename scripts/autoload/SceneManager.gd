extends CanvasLayer

signal scene_changed(scene_path: String)

const FADE_DURATION := 0.3

var _is_transitioning := false

@onready var _color_rect: ColorRect = $ColorRect
@onready var _tween: Tween


func _ready() -> void:
	_color_rect.color = Color.BLACK
	_color_rect.modulate.a = 0.0


func change_scene(path: String) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true
	await _fade_out()
	get_tree().change_scene_to_file(path)
	await _fade_in()
	_is_transitioning = false
	scene_changed.emit(path)


func _fade_out() -> void:
	_tween = create_tween()
	_tween.tween_property(_color_rect, "modulate:a", 1.0, FADE_DURATION)
	await _tween.finished


func _fade_in() -> void:
	_tween = create_tween()
	_tween.tween_property(_color_rect, "modulate:a", 0.0, FADE_DURATION)
	await _tween.finished
