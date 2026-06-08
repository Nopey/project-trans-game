@tool
extends Control
class_name InputSlots

@export var input_prompt_node: LineEdit
@export var signal_prompt_node: LineEdit

func set_text(value: String) -> void:
	input_prompt_node.text = value

func set_signal_value(value: String) -> void:
	signal_prompt_node.text = value

func get_input_prompt() -> String:
	return input_prompt_node.text

func get_signal_prompt() -> String:
	return signal_prompt_node.text
