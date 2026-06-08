extends CharcterState
class_name PlayerFallState

@export var fall_modifyer: float = 2.0

func update(delta) -> void:
	if character.is_on_floor():
		character.state_machine.change_state(character.walk_state)
	
	horizontal_movement(character.air_speed)
	apply_gravity(delta, fall_modifyer)
	character.move_and_slide()
