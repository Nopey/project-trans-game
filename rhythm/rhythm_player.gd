extends Sprite3D

@onready var shield: Sprite3D = $Shield

func _process(_delta: float) -> void:
	var held_dir: EnemyEye.DIRECTION = EnemyEye.CORRECT_INPUTS.find(EnemyEye.get_held_inputs()) as EnemyEye.DIRECTION
	if held_dir == -1:
		shield.hide()
	else:
		shield.show()
		var angle = -PI/2 -(held_dir as int) * TAU / 16.0
		var defend_dir_2d: Vector2 = Vector2.from_angle(angle)
		shield.position = 1.5 * Vector3(defend_dir_2d.x, 0, defend_dir_2d.y)
