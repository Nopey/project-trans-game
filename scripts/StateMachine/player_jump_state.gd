extends CharcterState
class_name PlayerJumpState

func enter() -> void:
	character.velocity.y += sqrt(character.jump_force * 2.0 * -character.get_gravity().y)
	character.move_and_slide()

func update(delta) -> void:
	if character.is_on_floor():
		character.state_machine.change_state(character.idle_state)
	if character.velocity.y < 0:
		character.state_machine.change_state(character.fall_state)
	
	horizontal_movement(character.air_speed)
	apply_gravity(delta)
	character.move_and_slide()
