extends CharcterState
class_name PlayerWalkState

#func enter() -> void:
	#character.rig.rpc("walk")

func update(delta) -> void:
	if Input.is_action_pressed("sprint"):
		character.state_machine.change_state(character.sprint_state)
	ground_check()
	if character.input == Vector3.ZERO:
		character.state_machine.change_state(character.idle_state)
	horizontal_movement(character.walk_speed)
	character.move_and_slide()

func input(event: InputEvent) -> void:
	ground_input_checks(event)
