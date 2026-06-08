extends Resource
class_name DialogPathResourse


@export var dialog_nodes_position: Array[Vector2]
@export var dialog_nodes_size: Array[Vector2]
@export var dialog_text: Array[String]
@export var dialog_connection_slots: Array[int]
@export var dialog_connection_text: Array[Array]
@export var dialog_connection_signals: Array[Array]
@export var nodes_names: Array[String]
@export var connections: Array
@export var max_connection: int
#@export var nodes: Array[dialogNode]

func save_tree(dialog_nodes_to_save: Array[Vector2], dialog_nodes_size_to_save: Array[Vector2], dialog_text_to_save: Array[String], connections_to_save, dialog_connection_slots_to_save: Array[int], dialog_connection_slots_text_to_save: Array[Array], dialog_connection_slots_signals_to_save: Array[Array], nodes_names_to_save: Array[String], max_connection_to_save: int) -> void:
	dialog_nodes_position.clear()
	dialog_nodes_size.clear()
	dialog_text.clear()
	dialog_connection_slots.clear()
	dialog_connection_text.clear()
	dialog_connection_signals.clear()
	nodes_names.clear()
	connections.clear()
	dialog_nodes_position.append_array(dialog_nodes_to_save)
	dialog_nodes_size.append_array(dialog_nodes_size_to_save)
	dialog_text.append_array(dialog_text_to_save)
	dialog_connection_slots.append_array(dialog_connection_slots_to_save)
	dialog_connection_text.append_array(dialog_connection_slots_text_to_save)
	dialog_connection_signals.append_array(dialog_connection_slots_signals_to_save)
	nodes_names.append_array(nodes_names_to_save)
	connections.append_array(connections_to_save)
	max_connection = max_connection_to_save

func get_number_of_connections_on_node(name: String) -> int:
	var amount_of_connections: int = 0
	
	for connection_array in connections:
		if connection_array["from_node"] == name:
			amount_of_connections += 1
	
	return amount_of_connections

func get_input_signals_of_node(index: int) -> Array:
	return dialog_connection_signals[index]

func get_input_texts_of_node(index: int) -> Array:
	return dialog_connection_text[index]
	#name: String
	#var index: int = 0
	#var texts: Array[String]
	#var found_instance: bool = false
	#
	#for connection_array in connections:
		#if connection_array["from_node"] == name:
			#texts.append_array(dialog_connection_text[index])
			#found_instance = true
		#if found_instance:
			#return texts
		#index += 1
	#
	#return texts

func get_connection_on_node(name: String, connection_index: int) -> String:
	var connections_on_node: String
	#var connections_on_node: Array[String] = []
	#var corasponding_index: Array[int] = []
	
	for connection_array in connections:
		if connection_array["from_node"] == name:
			if connection_array["from_port"] == connection_index:
				#connections_on_node.append(connection_array["to_node"])
				connections_on_node = connection_array["to_node"]
			#corasponding_index.append(connection["from_port"])
	#if connections_on_node.size() == 0:
		#return dialogEditorUI.END_NODE_NAME
	#return connections_on_node[connection_index]
	return connections_on_node
