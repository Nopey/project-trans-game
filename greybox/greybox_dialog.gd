extends VisualNovelBase

func _ready() -> void:
	play_greybox_dialog()

func play_greybox_dialog() -> void:
	engine.play_vn(greybox_dialog)

@onready var greybox_dialog = [
	[func(): print("greybox_dialog.gd can run arbitrary gdscript in here :3")],
	[vn_dialog, "Hello, world! This is a test message."],
	[vn_wait_for_click],
	[vn_dialog, "Another message."],
	[vn_wait_for_click],
	[vn_stop],
];
