extends CharacterBody3D
class_name CharacterController

@export_subgroup("Movement Controllers")
@export var walk_speed: float = 5
@export var sprint_speed: float = 7.5
@export var air_speed: float = 5
@export var jump_force: float = 2

@export_subgroup("Camera Controllers")
@export var camera: Camera3D
@export var mouse_sensitivity: float = 0.005
@export var tilt_limit: float = deg_to_rad(90)

@export_subgroup("State Machine Controllers")
@export var state_machine: StateMachine
@export var idle_state: PlayerIdleState
@export var walk_state: PlayerWalkState
@export var sprint_state: PlayerSprintState
@export var jump_state: PlayerJumpState
@export var fall_state: PlayerFallState

var input: Vector3
var forward: Vector3

func _physics_process(_delta: float) -> void:
	#camera.global_position.y = rig.get_camera_y()
	#print(rig.get_camera_y())
	var new_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var normalized_input = Vector3(new_input.x, 0, new_input.y).normalized()
	var direction = global_transform.basis * normalized_input
	var forward_dir = global_transform.basis * Vector3.FORWARD
	input.x = direction.x
	input.z = direction.z
	forward.x = forward_dir.x
	forward.z = forward_dir.z

func _unhandled_input(event: InputEvent) -> void:
	# Mouselook implemented using `screen_relative` for resolution-independent sensitivity.
	if event is InputEventMouseMotion:
		camera.rotation.x -= event.screen_relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		camera.rotation.x = clampf(camera.rotation.x, -tilt_limit, tilt_limit)
		rotation.y += -event.screen_relative.x * mouse_sensitivity
