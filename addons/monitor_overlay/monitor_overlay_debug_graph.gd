extends Control


var monitor: int
var monitor_name: String
var max_points := 100
var font: Font
var background_color: Color
var graph_color: Color
var normalize_units := true
var plot_graph := true
var unit: String
var thickness: float
var antialiased: bool

var _history := []
var _last_value: float


func _draw() -> void:
	_update_history()
	_draw_background_panel()
	_draw_graph()
	_draw_text()


func _draw_background_panel() -> void:
	var panel := Rect2()
	panel.position = get_canvas_transform().origin
	panel.size = size
	draw_rect(panel, background_color)


func _draw_text() -> void:
	var s_value := _normalize_value(_last_value)
	var text = monitor_name + ": " + s_value
	var position = get_canvas_transform().origin
	position.y += 16.0 # Font size
	draw_string(font, position, text)


# TODO: That function is unoptimized
func _draw_graph() -> void:
	if not plot_graph:
		return

	# Get the values range
	var min_value = _history[0]
	var max_value = _history[0]
	for value in _history:
		min_value = min(value, min_value)
		max_value = max(value, max_value)

	if min_value == max_value:
		min_value -= 1
		max_value += 1

	# Convert to 2D coordinates
	var x := 0.0
	var offset := size.x / max_points
	var height := size.y
	var margin = height / 10.0
	var origin := get_canvas_transform().origin
	var points = PackedVector2Array()
	
	for value in _history:
		value = remap(value, min_value, max_value, margin, height - margin)
		if x > 0:
			points.push_back(Vector2(x, height - value) + origin)
		
		x += offset
	
	if points.size() > 1:
		draw_polyline(points, graph_color, thickness, antialiased)


func _update_history():
	_last_value = Performance.get_monitor(monitor)
	if not plot_graph:
		return

	_history.push_back(_last_value)
	if _history.size() >= max_points:
		_history.pop_front()


func _normalize_value(value: float) -> String:
	var result := str(value) + unit

	if not normalize_units or _last_value == 0.0:
		return result

	if _last_value > 1000.0:
		var v = _last_value
		var index = -1
		while v > 1000.0 and index < 3:
			v /= 1000.0
			index += 1
		var scale = ["K", "M", "G", "T"]
		result = str(snapped(v, 0.001)) + scale[index] + unit

	if _last_value < 1.0:
		var v = _last_value
		var index = -1
		while v < 1.0 and index < 2:
			v *= 1000.0
			index += 1
		var scale = ["m", "u", "n"]
		result = str(snapped(v, 0.001)) + scale[index] + unit

	return result
