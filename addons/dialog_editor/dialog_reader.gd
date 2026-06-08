extends Node
## a custom node that reads dialog.
class_name DialogReader

## this signal is emited when you reach the end of a set of dialog
signal dialog_done
## this signal is emited when you chose a input with a value from the input
signal input_signal(signals: String)

## this is the dialog resourse this node will read.
@export var dialog_to_read: DialogPathResourse
## this node has is what you can use to give input to the story it should be a custom node.
## Just make sure it has a text value and it should be good.
@export var input_slot_labels: Array[Node]

var current_node: String = DialogEditorUI.START_NODE_NAME
var current_nodes_text: String
var input: int
var input_to_hide: Array[Node]
var last_right_index: int

## returns the name of the current dialog that is being read.
func get_current_dialog() -> String:
	return current_nodes_text

## gets the next node to read and updates the input_slot_labels text
func read_next_node() -> void:
	#if dialog_to_read.get_input_signals_of_node(input) != null:
		#input_signal.emit(dialog_to_read.get_input_signals_of_node(input))
	var signals = dialog_to_read.get_input_signals_of_node(last_right_index)
	var signal_index: int = 0
	for sign in signals:
		if signal_index == input:
			input_signal.emit(sign)
		signal_index += 1
	
	var number_of_conections = dialog_to_read.get_number_of_connections_on_node(current_node)
	input = clamp(input, 0, number_of_conections - 1)
	if input < 0:	input = 0
	var connection_on_current_node = dialog_to_read.get_connection_on_node(current_node, input)
	if connection_on_current_node == DialogEditorUI.END_NODE_NAME:
		dialog_done.emit()
		last_right_index = 0
		current_node = DialogEditorUI.START_NODE_NAME
		current_nodes_text = ""
		return
	current_node = connection_on_current_node
	var index: int = 0
	var right_index: int
	
	for name in dialog_to_read.nodes_names:
		if name == current_node:
			right_index = index
		index += 1
	
	current_nodes_text = dialog_to_read.dialog_text[right_index]
	
	
	var inputs_text = dialog_to_read.get_input_texts_of_node(right_index)
	var input_slot_index = 0
	input_to_hide.append_array(input_slot_labels)
	for text in inputs_text:
		input_slot_labels[input_slot_index].text = text
		input_slot_labels[input_slot_index].show()
		input_to_hide.erase(input_slot_labels[input_slot_index])
		input_slot_index += 1
	for input in input_to_hide:
		input.hide()
	input_to_hide.clear()
	
	last_right_index = right_index
