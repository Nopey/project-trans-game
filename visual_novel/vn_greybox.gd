extends VisualNovelBase

func _ready() -> void:
	self.engine.play_vn(test_script)

var test_script = [
	[vn_thing_zero],
	[vn_thing_one, PI],
	# ["this is not a valid function."],
	[vn_dialog, "This is a test dialog. "],
	[vn_dialog_append, "This is, too.", DialogBox.RevealKind.LETTERS, 0.02],
	[vn_wait_for_click],
	[func(): create_tween().tween_property($Doll1,
		"position", Vector3(4, 0, 0), 1.0
	)],
	[func(): create_tween().tween_property($Doll2,
		"position", Vector3(-4, 0, 0), 1.0
	)],
	[vn_dialog, "Hello, [b]World[/b]! " + \
		"[color=green][i]How are you doing today?[/i][/color] " + \
		"Have you seen what the " + \
		"Rock[char=0020][img=16x16]visual_novel/placeholder_rock.png[/img]" + \
		" is cookin'?"
	],
	[vn_wait_for_click],
	[vn_dialog, "This test dialog will be replaced once the sentence is revealed.", DialogBox.RevealKind.WORDS, 0.05],
	[vn_wait_for_dialog],
	[vn_dialog, "Boo!", DialogBox.RevealKind.LETTERS, 0.1],
	[vn_wait_for_click],
	[vn_dialog, "This test involves an unskippable three-second sleep.", DialogBox.RevealKind.WORDS, 0.1],
	[vn_wait_for_click],
	[vn_dialog, "Mom", DialogBox.RevealKind.INSTANT],
	[vn_dialog_append, "...", DialogBox.RevealKind.LETTERS, 0.5],
	[vn_set_reveal_on_click, false],
	[vn_sleep, 3, false],
	[vn_set_reveal_on_click, true],
	[vn_wait_for_click],
	[vn_dialog, "Dramatic pause for effect, anyone?", DialogBox.RevealKind.WORDS, 0.1],
	[vn_goto, "test_label"],
	["this is also not a function, but should be jumped over."],
	[vn_label, "test_label"],
	[vn_thing_two, 42, "Hello!"],
	[vn_dialog, "(end of test script)"],
]

# we can define methods inside scripts and use them as vn instructions :)
func vn_thing_zero():
	print("vn thing zero. has ref to self: ", self)

func vn_thing_one(a: float):
	print("vn thing one: ", a)

func vn_thing_two(a: int, b: String):
	print("vn thing two: ", a, " ", b)
