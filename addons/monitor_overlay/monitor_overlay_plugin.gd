@tool
extends EditorPlugin


func get_name():
	return "MonitorOverlay"


func _enter_tree():
	add_custom_type(
		"MonitorOverlay",
		"VBoxContainer",
		load("res://addons/monitor_overlay/monitor_overlay.gd"),
		load("res://addons/monitor_overlay/icon.svg")
	)

func _exit_tree():
	remove_custom_type("MonitorOverlay")
