extends VisualNovelBase
class_name VisualNovelEngine
## A simple register-based virtual machine
##
## A virtual machine is used to enable dialog rollback and save/restore,
## and because functions suspended awaiting for a signal or coroutine may
## be cancelled when a GDScript is edited.

# two cameras, so we can screenshake the 3D and 2D (UI) content.
#@onready var camera_3d = $Camera3D
#@onready var camera_2d = $Camera2D

@onready var dialog_box: DialogBox = $"Dialog Box"
@onready var sleep_timer: Timer = $"Sleep Timer"
@onready var skip_timer: Timer = $"Skip Timer"
@onready var item_notification: TextureRect = $"Item Notification"
var item_notification_tween: Tween
var self_control = self as Node as Control

var active_script: Array
var instruction_index: int ## the next instruction to be executed

func resume_vn() -> void:
	sleep_timer.stop()
	while instruction_index < active_script.size():
		var entry: Array = active_script[instruction_index]
		instruction_index += 1
		var command = entry[0]
		if command is Callable:
			var result = command.callv(entry.slice(1))
			if result and result is Callable and result == vnr_suspend:
				return
			elif result:
				printerr("Unexpected command result: ", result)
		else:
			printerr("Unsure what to do with command '", command, "'")
	resume_on_click = false

func _ready() -> void:
	dialog_box.dialog_finished.connect(_on_dialog_finished)
	item_notification.modulate.a = 0
	if not self.is_vn_playing():
		self_control.hide()
		dialog_box.clear_dialog()

func _process(_delay: float) -> void:
	if skip_timer.is_stopped() and Input.is_action_pressed("dialog_skip"):
		skip_timer.start(0.08)
		skip_timer.one_shot = true
		_on_click()

func is_vn_playing():
	return active_script and instruction_index < active_script.size()

func play_vn(instructions: Array, starting_index: int = 0):
	self_control.show()
	active_script = instructions
	instruction_index = starting_index
	resume_vn()

func stop_vn():
	self_control.hide()
	dialog_box.clear_dialog()
	active_script = []
	instruction_index = 0

# click, or space bar.
var resume_on_click: bool
var reveal_on_click: bool = true
func _on_click() -> void:
	if !dialog_box.is_dialog_finished():
		if not reveal_on_click:
			#print("_on_click: not skipping dialog, reveal_on_click is false!")
			return
		#print("_on_click: finishing dialog.")
		dialog_box.finish_dialog()
	elif resume_on_click:
		#print("_on_click: resuming vn")
		resume_vn()

var resume_on_dialog_finished: bool
func _on_dialog_finished() -> void:
	if resume_on_dialog_finished:
		#print("dialog finished, resuming")
		resume_on_dialog_finished = false
		resume_vn()

# TODO: `signal click` on DialogBox, subscribe to it from here (VNEngine).
func _gui_input(event: InputEvent):
	var event_mouse_button: InputEventMouseButton = event as InputEventMouseButton
	if event_mouse_button and event_mouse_button.pressed and event_mouse_button.button_index == MOUSE_BUTTON_LEFT:
		_on_click()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		_on_click()
