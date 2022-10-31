@tool
extends VBoxContainer

const DebugGraph := preload("./monitor_overlay_debug_graph.gd")

# Graph options
var background_color := Color(0.0, 0.0, 0.0, 0.5)
var plot_graphs := true
var graph_color := Color.ORANGE
var normalize_units := true
var history := 100
var graph_height := 50

# Monitors
var fps := true:
	set(value):
		fps = value
		rebuild_ui()
var process := false:
	set(value):
		process = value
		rebuild_ui()
var physics_process := false:
	set(value):
		physics_process = value
		rebuild_ui()
var static_memory := false:
	set(value):
		static_memory = value
		rebuild_ui()
var max_static_memory := false:
	set(value):
		max_static_memory = value
		rebuild_ui()
var max_message_buffer := false:
	set(value):
		max_message_buffer = value
		rebuild_ui()
var objects := false:
	set(value):
		objects = value
		rebuild_ui()
var resources := false:
	set(value):
		resources = value
		rebuild_ui()
var nodes := false:
	set(value):
		nodes = value
		rebuild_ui()
var orphan_nodes := false:
	set(value):
		orphan_nodes = value
		rebuild_ui()
var objects_drawn := false:
	set(value):
		objects_drawn = value
		rebuild_ui()
var primitives_drawn := false:
	set(value):
		primitives_drawn = value
		rebuild_ui()
var total_draw_calls := false:
	set(value):
		total_draw_calls = value
		rebuild_ui()
var video_memory := false:
	set(value):
		video_memory = value
		rebuild_ui()
var texture_memory := false:
	set(value):
		texture_memory = value
		rebuild_ui()
var buffer_memory := false:
	set(value):
		buffer_memory = value
		rebuild_ui()
var active_objects_2d := false:
	set(value):
		active_objects_2d = value
		rebuild_ui()
var collision_pairs_2d := false:
	set(value):
		collision_pairs_2d = value
		rebuild_ui()
var islands_2d := false:
	set(value):
		islands_2d = value
		rebuild_ui()
var active_objects_3d := false:
	set(value):
		active_objects_3d = value
		rebuild_ui()
var collision_pairs_3d := false:
	set(value):
		collision_pairs_3d = value
		rebuild_ui()
var islands_3d := false:
	set(value):
		islands_3d = value
		rebuild_ui()
var audio_output_latency := false:
	set(value):
		audio_output_latency = value
		rebuild_ui()

var _property_list := []
var _graphs := []


func _ready():
	_init_property_list()
	if custom_minimum_size.x == 0:
		custom_minimum_size.x = 300
	rebuild_ui()


func _get_property_list() -> Array:
	return _property_list


# We manualy define exposed properties here instead of using the @export
# annotation so we can define categories, groups and subgroups.
func _init_property_list() -> void:
	_property_list.clear()

	_add_script_category("MonitorOverlay")

	_add_script_group("Active monitors")
	_add_script_subgroup("Time")
	_add_script_property("fps", TYPE_BOOL, true)
	_add_script_property("process", TYPE_BOOL, true)
	_add_script_property("physics_process", TYPE_BOOL, false)

	_add_script_subgroup("Memory")
	_add_script_property("static_memory", TYPE_BOOL, false)
	_add_script_property("max_static_memory", TYPE_BOOL, false)
	_add_script_property("max_message_buffer", TYPE_BOOL, false)

	_add_script_subgroup("Object")
	_add_script_property("objects", TYPE_BOOL, false)
	_add_script_property("resources", TYPE_BOOL, false)
	_add_script_property("nodes", TYPE_BOOL, false)
	_add_script_property("orphan_nodes", TYPE_BOOL, false)

	_add_script_subgroup("Raster")
	_add_script_property("objects_drawn", TYPE_BOOL, false)
	_add_script_property("primitives_drawn", TYPE_BOOL, false)
	_add_script_property("total_draw_calls", TYPE_BOOL, false)

	_add_script_subgroup("Video")
	_add_script_property("video_memory", TYPE_BOOL, false)
	_add_script_property("texture_memory", TYPE_BOOL, false)
	_add_script_property("buffer_memory", TYPE_BOOL, false)

	_add_script_subgroup("Physics 2D")
	_add_script_property("active_objects_2d", TYPE_BOOL, false)
	_add_script_property("collision_pairs_2d", TYPE_BOOL, false)
	_add_script_property("islands_2d", TYPE_BOOL, false)

	_add_script_subgroup("Physics 3D")
	_add_script_property("active_objects_3d", TYPE_BOOL, false)
	_add_script_property("collision_pairs_3d", TYPE_BOOL, false)
	_add_script_property("islands_3d", TYPE_BOOL, false)

	_add_script_subgroup("Audio")
	_add_script_property("audio_output_latency", TYPE_BOOL, false)

	_add_script_group("Options")
	_add_script_property("normalize_units", TYPE_BOOL, true)
	_add_script_property("plot_graphs", TYPE_BOOL, true)
	_add_script_property("history", TYPE_INT, 100)
	_add_script_property("background_color", TYPE_COLOR, Color(0.0, 0.0, 0.0, 0.5))
	_add_script_property("graph_color", TYPE_COLOR, Color.ORANGE)
	_add_script_property("graph_height", TYPE_INT, 50)


func _add_script_category(category_name: String) -> void:
	_property_list.push_back({
		name = category_name,
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE,
	})


func _add_script_group(group_name: String) -> void:
	_property_list.push_back({
		name = group_name,
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
	})


func _add_script_subgroup(subgroup_name: String) -> void:
	_property_list.push_back({
		name = subgroup_name,
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_SUBGROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
	})


func _add_script_property(property_name: String, type: int, value) -> void:
	_property_list.push_back({
		name = property_name,
		type = type,
		value = value
	})


func clear() -> void:
	for graph in _graphs:
		graph.queue_free()
	_graphs = []


func rebuild_ui() -> void:
	clear()
	if fps:
		_create_graph_for(Performance.TIME_FPS, "FPS")

	if process:
		_create_graph_for(Performance.TIME_PROCESS, "Process", "s")

	if physics_process:
		_create_graph_for(Performance.TIME_PHYSICS_PROCESS, "Physics Process", "s")

	if static_memory:
		_create_graph_for(Performance.MEMORY_STATIC, "Static Memory", "B")

	if max_static_memory:
		_create_graph_for(Performance.MEMORY_STATIC_MAX, "Max Static Memory", "B")

	if max_message_buffer:
		_create_graph_for(Performance.MEMORY_MESSAGE_BUFFER_MAX, "Message Buffer Max")

	if objects:
		_create_graph_for(Performance.OBJECT_COUNT, "Objects")

	if resources:
		_create_graph_for(Performance.OBJECT_RESOURCE_COUNT, "Resources")

	if nodes:
		_create_graph_for(Performance.OBJECT_NODE_COUNT, "Nodes")

	if orphan_nodes:
		_create_graph_for(Performance.OBJECT_ORPHAN_NODE_COUNT, "Orphan Nodes")

	if objects_drawn:
		_create_graph_for(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME, "Objects Drawn")

	if primitives_drawn:
		_create_graph_for(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME, "Primitives Drawn")

	if total_draw_calls:
		_create_graph_for(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME, "3D Draw Calls")

	if video_memory:
		_create_graph_for(Performance.RENDER_VIDEO_MEM_USED, "Video Memory", "B")

	if texture_memory:
		_create_graph_for(Performance.RENDER_TEXTURE_MEM_USED, "Texture Memory", "B")

	if buffer_memory:
		_create_graph_for(Performance.RENDER_BUFFER_MEM_USED, "Vertex Memory", "B")

	if active_objects_2d:
		_create_graph_for(Performance.PHYSICS_2D_ACTIVE_OBJECTS, "2D Active Objects")

	if collision_pairs_2d:
		_create_graph_for(Performance.PHYSICS_2D_COLLISION_PAIRS, " 2D Collision Pairs")

	if islands_2d:
		_create_graph_for(Performance.PHYSICS_2D_ISLAND_COUNT, "2D Islands")

	if active_objects_3d:
		_create_graph_for(Performance.PHYSICS_3D_ACTIVE_OBJECTS, " 3D Active Objects")

	if collision_pairs_3d:
		_create_graph_for(Performance.PHYSICS_3D_COLLISION_PAIRS, "3D Collision Pairs")

	if islands_3d:
		_create_graph_for(Performance.PHYSICS_3D_ISLAND_COUNT, "3D Islands")

	if audio_output_latency:
		_create_graph_for(Performance.AUDIO_OUTPUT_LATENCY, "Audio Latency", "s")


func _process(_delta: float) -> void:
	for item in _graphs:
		item.queue_redraw()


func _create_graph_for(monitor: int, monitor_name: String, unit: String = "") -> void:
	var graph = DebugGraph.new()
	graph.monitor = monitor
	graph.monitor_name = monitor_name
	graph.font = get_theme_default_font()
	graph.custom_minimum_size.y = graph_height
	graph.max_points = history
	graph.background_color = background_color
	graph.graph_color = graph_color
	graph.plot_graph = plot_graphs
	graph.unit = unit
	graph.normalize_units = normalize_units

	add_child(graph)
	_graphs.push_back(graph)
