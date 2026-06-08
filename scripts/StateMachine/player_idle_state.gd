extends CharcterState
class_name PlayerIdleState

#func enter() -> void:
	#character.rig.rpc("idle")

func update(delta) -> void:
	ground_check()
	if character.input != Vector3.ZERO:
		character.state_machine.change_state(character.walk_state)

func input(event: InputEvent) -> void:
	ground_input_checks(event)
