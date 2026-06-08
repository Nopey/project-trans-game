@tool
extends EditorPlugin

var dialog_editor_menu

func _enter_tree() -> void:
	dialog_editor_menu = preload("res://addons/dialog_editor/dialog_ui.tscn").instantiate()
	add_custom_type("DialogReader", "Node", preload("res://addons/dialog_editor/dialog_reader.gd"), preload("res://addons/dialog_editor/DialogEditorIcon.svg"))
	#add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, my_custom_menu)
	add_control_to_dock(EditorPlugin.DOCK_SLOT_BOTTOM, dialog_editor_menu)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_docks(dialog_editor_menu)
	remove_custom_type("DialogReader")
