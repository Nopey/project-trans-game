@tool
extends GraphNode
class_name DialogNode

@export var text_edit: TextEdit
@export var input_slot: PackedScene
@export var spin_box: SpinBox

var answer_index: int = 0
var text: String
var input_value: int = 0
var max_input_slots: int = 100000
var input_slots: Array[InputSlots]
var current_number_of_slots = 2

func _ready() -> void:
	_on_spin_box_value_changed(1)

func set_up() -> void:
	spin_box.max_value = max_input_slots
	if input_slots.size() == 0 and spin_box.value > 0:
		spin_box.value = spin_box.value

func get_text() -> String:
	text = text_edit.text
	return text

func set_text(input_text: String) -> void:
	text = input_text
	text_edit.text = input_text

func get_input_slot_text() -> Array[String]:
	var texts: Array[String]
	for input in input_slots:
		texts.append(input.get_input_prompt())
	return texts

func get_input_slot_signal() -> Array[String]:
	var signals: Array[String]
	for input in input_slots:
		signals.append(input.get_signal_prompt())
	return signals

func set_input_slot_text(texts: Array[String]) -> void:
	var index: int = 0
	
	for input in input_slots:
		input.set_text(texts[index])
		index += 1

func set_input_slot_signals(signals: Array[String]) -> void:
	var index: int = 0
	
	for input in input_slots:
		input.set_signal_value(signals[index])
		index += 1

func _on_delete_request() -> void:
	queue_free()

func set_slot_amount(value: int) -> void:
	spin_box.value = value

func set_max_input_slots(value: int) -> void:
	max_input_slots = value
	spin_box.max_value = max_input_slots
	if spin_box.value > max_input_slots:
		spin_box.value = max_input_slots

func _on_spin_box_value_changed(value: float) -> void:
	if value > max_input_slots:
		spin_box.value = max_input_slots
		value = max_input_slots
	while value != input_value:
		if value > input_value:
			var node = input_slot.instantiate()
			add_child(node)
			input_slots.append(node)
			set_slot((current_number_of_slots), false, 0, Color.WHITE, true, 0, Color.WHITE)
			input_value += 1
			current_number_of_slots += 1
		if value < input_value:
			var node_to_delete = input_slots[input_slots.size() - 1]
			input_slots.erase(node_to_delete)
			current_number_of_slots -= 1
			node_to_delete.queue_free()
			input_value -= 1
