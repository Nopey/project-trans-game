extends TextureRect
class_name DialogBox

var display_blinky: bool

@onready var rich_text_label: RichTextLabel = $RichTextLabel
var reveal_tween: Tween

signal dialog_finished()

func _ready() -> void:
	rich_text_label.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING

func clear_dialog() -> void:
	rich_text_label.clear()
	if reveal_tween:
		reveal_tween.kill()
		reveal_tween = null

func reveal_dialog_append(passage: String, delay_secs: float) -> void:
	if not reveal_tween or not reveal_tween.is_running():
		reveal_tween = create_tween()
		reveal_tween.tween_property(rich_text_label, "visible_characters", 0, 0.0)

	var old_count = rich_text_label.get_total_character_count()
	rich_text_label.append_text(passage)
	var append_len = rich_text_label.get_total_character_count() - old_count
	var duration = append_len * delay_secs
	# print("Appending ", append_len, " characters, tween duration ", duration)
	reveal_tween.tween_property(rich_text_label, "visible_characters", rich_text_label.get_total_character_count(), duration)
	reveal_tween.tween_callback(check_dialog_finished)

func is_dialog_finished() -> bool:
	return not reveal_tween or not reveal_tween.is_running()

func finish_dialog() -> void:
	if reveal_tween:
		reveal_tween.kill()
		reveal_tween = null
	rich_text_label.visible_characters = -1

func check_dialog_finished() -> void:
	if is_dialog_finished():
		dialog_finished.emit()
