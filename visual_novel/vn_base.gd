extends Node
class_name VisualNovelBase
## Visual Novel Base provides everything needed to
## write a visual novel script (list of instructions).
##
## Execution is done by the 'VisualNovel' engine (visual_novel.gd).
##
## Individual Scene's VN Scripts are expected to extend this class,
## and then pass the instructions to the VN engine.

# this is guaranteed to be set during visual novel execution,
# but may be null before that.
@onready var engine: VisualNovelEngine = get_tree().current_scene.find_child("VisualNovelEngine")

#region visual novel instructions (methods)
func vn_stop() -> void:
	engine.stop_vn()

func vn_goto(label_name: String):
	for index in engine.active_script.size():
		var entry: Array = engine.active_script[index]
		if entry[0] is Callable and entry[0] == vn_label and entry[1] == label_name:
			engine.instruction_index = index
			return
	printerr("vn_goto: Failed to find label '",label_name,"'")

func vn_label(_label_name: String):
	pass

func vn_sleep(time_sec: float, click_to_skip: bool = true):
	if not engine.sleep_timer.timeout.is_connected(_on_sleep_timer_timeout):
		engine.sleep_timer.timeout.connect(_on_sleep_timer_timeout)
	engine.sleep_timer.start(time_sec)
	engine.resume_on_click = click_to_skip
	engine.dialog_box.display_blinky = false # maybe ?
	return vnr_suspend

func _on_sleep_timer_timeout():
	engine.resume_vn()

func vn_wait_for_click():
	engine.resume_on_click = true
	engine.dialog_box.display_blinky = true
	return vnr_suspend

func vn_item_notification(image_path: String) -> void:
	if engine.item_notification_tween:
		engine.item_notification_tween.kill()
	engine.item_notification.texture = ResourceLoader.load(image_path)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	if Input.is_action_pressed("dialogSkip"):
		tween.tween_property(engine.item_notification, "scale", Vector2(1.2, 1.2), 0.2)
		tween.parallel().tween_property(engine.item_notification, "modulate:a", 1, 0)
	else:
		tween.tween_property(engine.item_notification, "scale", Vector2(1.2, 1.2), 0.4)
		tween.parallel().tween_property(engine.item_notification, "modulate:a", 1, 0.5)
	tween.tween_property(engine.item_notification, "scale", Vector2(1.2, 1.2), 0.3)
	tween.tween_property(engine.item_notification, "modulate:a", 0, 0.2).set_delay(0.4)
	engine.item_notification_tween = tween

#region vn_dialog
func vn_dialog(passage: String, delay_secs: float = 0.06):
	engine.dialog_box.clear_dialog()
	vn_dialog_append(passage, delay_secs)
func vn_dialog_append(passage: String, delay_secs: float = 0.06) :
	if Input.is_action_pressed("dialog_skip"):
		delay_secs = 0
	engine.dialog_box.reveal_dialog_append(passage, delay_secs)

## Waits for the currently queued dialog to be revealed before continuing, which
##  can be triggered by an impatient player's click.
func vn_wait_for_dialog():
	assert(not engine.dialog_box.is_dialog_finished())
	engine.resume_on_click = false
	engine.resume_on_dialog_finished = true
	engine.dialog_box.display_blinky = false
	return vnr_suspend

# Allows 'reveal dialog on click' behavior to be suppressed if needed.
func vn_set_reveal_on_click(val: bool):
	engine.reveal_on_click = val
#endregion

#endregion

#region vnr_
# vnr_ are sentinel "vn result" values which the above vn_ functions may return.

## Suspend execution of the script until _on_resume_vn is called
static func vnr_suspend():
	printerr("not to be called")

#endregion
