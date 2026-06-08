@tool
extends Control
class_name DialogEditorUI

const START_NODE_NAME: String = "StartNode"
const END_NODE_NAME: String = "EndNode"

@export var dialog_node: PackedScene
@export var start_node_scene: PackedScene
@export var end_node_scene: PackedScene
@export var start_node: GraphNode
@export var end_node: EndNode
@export var graph: GraphEdit
@export var resourse_to_save_line_edit: LineEdit
@export var max_input_slot_spin_box: SpinBox
@export var settings_menu: CenterContainer

var start_offset: Vector2 = Vector2.ZERO
var offset_increase_amount: Vector2 = Vector2(100, 100)
var offset: Vector2
var current_node_id: int = 0
var max_slots_on_dialog_node: int = 10
var current_node: GraphNode

func _ready() -> void:
	var node = start_node_scene.instantiate()
	var end_node_instance = end_node_scene.instantiate()
	graph.add_child(node)
	graph.add_child(end_node_instance)
	current_node_id = 0
	current_node = node
	start_node = node
	end_node = end_node_instance
	start_node.name = START_NODE_NAME
	end_node.name = END_NODE_NAME


func get_connections(node_name):
	var ret = {"left": [], "right": []}
	for conn in graph.connections:
		if node_name == conn["from_node"]: ret["right"].append(conn["to_node"])
		elif node_name == conn["to_node"]: ret["left"].append(conn["from_node"])
	return ret

func _on_add_node_button_pressed() -> void:
	var node: GraphNode = dialog_node.instantiate()
	if node is DialogNode:
		node.max_input_slots = max_slots_on_dialog_node
	graph.add_child(node)
	node.position_offset += offset
	offset += offset_increase_amount

func get_next_node() -> void:
	if current_node is DialogNode:
		if current_node.answer:
			current_node = graph.connections[current_node_id].find_key("to_node")
			#current_node_id += 1
		else:
			current_node = graph.connections[current_node_id].find_key("to_node")
			#current_node_id += 1
	else:
		current_node = graph.connections[current_node_id].find_key("to_node")
		#current_node_id += 1

func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	# disconnect any preexisting 'from' port connections
	for connection in graph.connections:
		if connection["from_node"] == from_node and connection["from_port"] == from_port:
			graph.disconnect_node(from_node, from_port, connection["to_node"], connection["to_port"])

	graph.connect_node(from_node, from_port, to_node, to_port)
	get_next_node()


func _on_graph_edit_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph.disconnect_node(from_node, from_port, to_node, to_port)


func _on_graph_edit_delete_nodes_request(nodes: Array[StringName]) -> void:
	for c in graph.get_children():
		if not c is EndNode:
			if c is GraphNode and c.is_selected():
				c.queue_free()

func _on_GraphEdit_duplicate_nodes_request():
	for c in graph.get_children():
		if not c is EndNode:
			if c is GraphNode and c.is_selected():
				var new_c: DialogNode = dialog_node.instantiate()
				c.set_selected(false)
				new_c.set_selected(true)
				new_c.size = c.size
				new_c.set_position_offset(c.position_offset + offset_increase_amount)
				graph.add_child(new_c)
				new_c.set_text(c.get_text())
				new_c.set_max_input_slots(max_slots_on_dialog_node)
				new_c.set_slot_amount(c.input_value)
				new_c.set_input_slot_text(c.get_input_slot_text())
				new_c.set_input_slot_signals(c.get_input_slot_signal())
				new_c.name = str(randi())

func _on_graph_edit_connection_from_empty(to_node: StringName, to_port: int, release_position: Vector2) -> void:
	var new_node = dialog_node.instantiate()
	if new_node is DialogNode:
		new_node.max_input_slots = max_slots_on_dialog_node
	new_node.set_position_offset((graph.scroll_offset + graph.size / 2) / graph.zoom - new_node.size / 2)
	graph.add_child(new_node)
	new_node.name = str(randi())
	graph.connect_node(new_node.name, 0, to_node, to_port)



func _on_graph_edit_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	var new_node = dialog_node.instantiate()
	if new_node is DialogNode:
		new_node.max_input_slots = max_slots_on_dialog_node
	new_node.set_position_offset((graph.scroll_offset + graph.size / 2) / graph.zoom - new_node.size / 2)
	graph.add_child(new_node)
	new_node.name = str(randi())
	graph.connect_node(from_node, from_port, new_node.name, 0)


func _on_save_graph_button_pressed() -> void:
	print("Saving...")
	var save_path: String = resourse_to_save_line_edit.text
	var save_graph_resoures = DialogPathResourse.new()
	save_graph_resoures.take_over_path(save_path)

	
	var nodes_positions_to_save: Array[Vector2]
	var nodes_size_to_save: Array[Vector2]
	var text_to_save: Array[String]
	var connection_amount_to_save: Array[int]
	var dialog_connection_slots_text_to_save: Array[Array]
	var dialog_connection_slots_signals_to_save: Array[Array]
	var nodes_names_to_save: Array[String]
	for child in graph.get_children():
		if child is DialogNode:
			nodes_positions_to_save.append(child.position_offset)
			nodes_size_to_save.append(child.size)
			text_to_save.append(child.get_text())
			connection_amount_to_save.append(child.input_value)
			dialog_connection_slots_text_to_save.append(child.get_input_slot_text())
			dialog_connection_slots_signals_to_save.append(child.get_input_slot_signal())
			nodes_names_to_save.append(child.name)
		#if child is EndNode:
			#nodes_positions_to_save.append(child.position_offset)
			#nodes_size_to_save.append(child.size)
			#text_to_save.append("null")
			#connection_amount_to_save.append(0)
			#dialog_connection_slots_text_to_save.append(null)
			#nodes_names_to_save.append(child.name)
	nodes_positions_to_save.append(end_node.position_offset)
	nodes_size_to_save.append(end_node.size)
	text_to_save.append("null")
	connection_amount_to_save.append(0)
	var array_to_use: Array
	array_to_use.append(null)
	dialog_connection_slots_text_to_save.append(array_to_use)
	dialog_connection_slots_signals_to_save.append(array_to_use)
	nodes_names_to_save.append(end_node.name)
	
	save_graph_resoures.save_tree(nodes_positions_to_save, nodes_size_to_save, text_to_save, graph.connections, connection_amount_to_save, dialog_connection_slots_text_to_save, dialog_connection_slots_signals_to_save, nodes_names_to_save, max_slots_on_dialog_node)
	ResourceSaver.save(save_graph_resoures, resourse_to_save_line_edit.text)


func _on_load_graph_button_pressed() -> void:
	var save_graph_resoures: DialogPathResourse = ResourceLoader.load(resourse_to_save_line_edit.text)
	for child in graph.get_children():
		if child is DialogNode:
			graph.remove_child(child)
			child.queue_free()
	
	max_slots_on_dialog_node = save_graph_resoures.max_connection
	max_input_slot_spin_box.value = max_slots_on_dialog_node
	var index = 0
	for node_position in save_graph_resoures.dialog_nodes_position:
		var node: GraphNode
		if not save_graph_resoures.nodes_names[index] == END_NODE_NAME:
			node = dialog_node.instantiate()
			graph.add_child(node)
			node.set_max_input_slots(max_slots_on_dialog_node)
			node.set_slot_amount(save_graph_resoures.dialog_connection_slots[index])
			node.name = save_graph_resoures.nodes_names[index]
			node.set_text(save_graph_resoures.dialog_text[index])
			node.set_input_slot_text(save_graph_resoures.dialog_connection_text[index])
			node.set_input_slot_signals(save_graph_resoures.dialog_connection_signals[index])
		else:
			node = end_node
		node.position_offset = node_position
		node.size = save_graph_resoures.dialog_nodes_size[index]
		index += 1
	graph.connections = save_graph_resoures.connections


func _on_settings_button_pressed() -> void:
	settings_menu.visible = !settings_menu.visible


func _on_max_input_slots_spin_box_value_changed(value: float) -> void:
	max_slots_on_dialog_node = value
	for child in graph.get_children():
		if child is DialogNode:
			child.set_max_input_slots(max_slots_on_dialog_node)


func _on_close_button_pressed() -> void:
	settings_menu.visible = false
