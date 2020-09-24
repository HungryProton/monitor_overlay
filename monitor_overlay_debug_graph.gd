extends Control


var monitor: int
var monitor_name: String
var max_points := 100
var font: Font
var background_color: Color
var graph_color: Color
var normalize_units := true

var _history := []
var _last_value: float
var _units = ["K", "M", "G", "T"]


func _draw() -> void:
	_update_history()
	_draw_background_panel()
	_draw_text()
	_draw_graph()


func _draw_background_panel() -> void:
	var panel := Rect2()
	panel.position = get_canvas_transform().origin
	panel.size = rect_size
	draw_rect(panel, background_color)


func _draw_text() -> void:
	var s_value := String(_last_value)
	if normalize_units and _last_value > 1000.0:
		var v = _last_value
		var index = -1
		while v > 1000.0 and index < 4:
			v /= 1000.0
			index += 1
		s_value = String(stepify(v, 0.001)) + _units[index]
	
	var text = monitor_name + ": " + s_value

	var position = get_canvas_transform().origin
	position.y += 16.0 # Font size
	draw_string(font, position, text)


# TODO: That function is unoptimized
func _draw_graph() -> void:
	# Get the values range
	var min_value = _history[0]
	var max_value = _history[0]
	for value in _history:
		if value < min_value:
			min_value = value
		if value > max_value:
			max_value = value

	var diff = (max_value - min_value) / 4.0
	if diff == 0.0:
		diff = 1.0
	min_value -= diff
	max_value += diff

	# Convert to 2D coordinates
	var x := 0.0
	var offset := rect_size.x / max_points
	var height := rect_size.y
	var origin := get_canvas_transform().origin
	var previous_point = Vector2.ZERO
	var next_point = Vector2.ZERO
	
	for value in _history:
		value = range_lerp(value, min_value, max_value, 0.0, height)
		next_point = Vector2(x, value) + origin
		draw_line(previous_point, next_point, graph_color)
		
		previous_point = next_point
		x += offset



func _update_history():
	_last_value = Performance.get_monitor(monitor)
	_history.push_back(_last_value)
	if _history.size() >= max_points:
		_history.pop_front()
