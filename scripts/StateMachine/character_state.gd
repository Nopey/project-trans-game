@abstract
extends State
class_name CharcterState

@export var character: CharacterController

func apply_gravity(delta: float, modifer: float = 1.0) -> void:
	character.velocity.y += character.get_gravity().y * modifer * delta

func horizontal_movement(speed: float = 1.0) -> void:
	character.velocity.x = character.input.x * speed
	character.velocity.z = character.input.z * speed

func ground_check() -> void:
	if not character.is_on_floor():
		character.state_machine.change_state(character.fall_state)

func ground_input_checks(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		character.state_machine.change_state(character.jump_state)
