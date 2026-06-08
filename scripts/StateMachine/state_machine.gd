extends Node
class_name StateMachine

@export var start_start: State

var owner_id = 1
var current_state: State

func _ready() -> void:
	current_state = start_start
	current_state.enter()

func _process(delta: float) -> void:
	if multiplayer.multiplayer_peer == null:
		return
	if owner_id != multiplayer.get_unique_id():
		return
	current_state.update(delta)

func _input(event: InputEvent) -> void:
	if owner_id != multiplayer.get_unique_id():
		return
	current_state.input(event)

func change_state(state: State) -> void:
	if owner_id != multiplayer.get_unique_id():
		return
	current_state.exit()
	current_state = state
	current_state.enter()
