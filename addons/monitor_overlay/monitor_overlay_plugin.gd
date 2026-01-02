@tool
extends EditorPlugin


func _get_plugin_name() -> String:
	return "MonitorOverlay"


func _get_plugin_icon() -> Texture2D:
	return load("./icon.svg")
