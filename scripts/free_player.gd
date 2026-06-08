extends CharacterBody3D
class_name FreePlayer

const MOVE_SPEED: float = 6
func _physics_process(_delta: float) -> void:
	# camera-relative movement (ehh..)
	'''
	var camera: Camera3D = get_viewport().get_camera_3d()
	var basis_x: Vector3 = camera.global_basis.x
	var basis_z: Vector3 = camera.global_basis.z
	basis_x.y = 0
	basis_z.y = 0
	basis_x = basis_x.normalized()
	basis_z = basis_z.normalized()
	'''
	# player-relative movement (slightly rotated relative to the camera, i think that's good? -M)
	var basis_x: Vector3 = global_basis.x
	var basis_z: Vector3 = global_basis.z

	var raw_input: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var input_3d = basis_x * raw_input.x + basis_z * raw_input.y
	velocity = MOVE_SPEED * input_3d
	move_and_slide()
