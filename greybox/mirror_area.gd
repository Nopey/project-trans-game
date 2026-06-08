extends Area3D

@onready var sprite: Sprite3D = $Sprite3D

func _on_body_entered(body: Node3D) -> void:
	if body is FreePlayer:
		sprite.show()
		print("show")

func _on_body_exited(body: Node3D) -> void:
	if body is FreePlayer:
		sprite.hide()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	sprite.hide()
