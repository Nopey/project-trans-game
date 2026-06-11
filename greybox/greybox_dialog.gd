extends VisualNovelBase

func _ready() -> void:
	play_greybox_dialog()

func play_greybox_dialog() -> void:
	engine.play_vn(greybox_dialog)

@onready var greybox_dialog = [
	[vn_dialog, "This is a test dialog. "],
	[vn_dialog_append, "This is, too.", 0.02],
	[vn_wait_for_click],
	[func(): print("greybox_dialog.gd can run arbitrary gdscript in here :3")],
	#[func(): create_tween().tween_property($Doll1,
	#	"position", Vector3(4, 0, 0), 1.0
	#)],
	[vn_dialog, "Hello, [b]World[/b]! " + \
		"[color=green][i]How are you doing today?[/i][/color] " + \
		"Have you seen what the Rock is cookin'?"
	],
	[vn_wait_for_click],
	# TODO: Mag: fix vn_wait_for_dialog
	#[vn_dialog, "This test dialog will be replaced once the sentence is revealed.", 0.05],
	#[vn_wait_for_dialog],
	#[vn_dialog, "Boo!", 0.1],
	#[vn_wait_for_click],
	[vn_dialog, "This next test involves an unskippable three-second sleep."],
	[vn_wait_for_click],
	[vn_dialog, "Mom", 0],
	[vn_dialog_append, "...", 0.5],
	[vn_set_reveal_on_click, false],
	[vn_sleep, 3, false],
	[vn_set_reveal_on_click, true],
	[vn_wait_for_click],
	[vn_dialog, "Dramatic pause for effect, anyone?"],
	[vn_goto, "test_label"],
	[vn_dialog_append, "this dialog will be skipped by the 'vn_goto' on the previous line."],
	[vn_label, "test_label"],
	[vn_wait_for_click],
	[vn_stop],
];
