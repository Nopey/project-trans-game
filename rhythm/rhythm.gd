extends Node3D
class_name Rhythm
## class for spawning enemies and such during rhythm minigame
##

var next_spawn: float = 1
func _process(delta: float) -> void:
	next_spawn -= delta
	if next_spawn > 0:
		return
	next_spawn += randf_range(1,2)
	var enemy_eye: Node3D = preload("res://rhythm/enemy_eye.tscn").instantiate()
	add_child(enemy_eye)
	enemy_eye.global_position += Vector3(0, 0, -7)
