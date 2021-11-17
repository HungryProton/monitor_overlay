extends VBoxContainer


@export var background_color := Color(0.0, 0.0, 0.0, 0.5)
@export var plot_graphs := true
@export var graph_color := Color.ORANGE
@export var normalize_units := true
@export var history := 100
@export var graph_height := 50


@export var fps := true
@export var process := false
@export var physics_process := false
@export var static_memory := false
@export var max_static_memory := false
@export var max_message_buffer := false
@export var objects := false
@export var resources := false
@export var nodes := false
@export var orphan_nodes := false
@export var objects_drawn := false
@export var primitives_drawn := false
@export var total_draw_calls := false
@export var video_memory := false
@export var texture_memory := false
@export var buffer_memory := false
@export var active_objects_2d := false
@export var collision_pairs_2d := false
@export var islands_2d := false
@export var active_objects_3d := false
@export var collision_pairs_3d := false
@export var islands_3d := false
@export var audio_output_latency := false


var _timer: Timer
var _font: Font = load("res://addons/monitor_overlay/font/overlay_font.tres")
var _debug_graph = load("res://addons/monitor_overlay/monitor_overlay_debug_graph.gd")
var _graphs := []


func _ready():
	if rect_min_size.x == 0:
		rect_min_size.x = 300
	rebuild_ui()


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


func _process(_delta) -> void:
	for item in _graphs:
		item.update()


func _create_graph_for(monitor: int, name: String, unit: String = "") -> void:
	var graph = _debug_graph.new()
	graph.monitor = monitor
	graph.monitor_name = name
	graph.font = _font
	graph.rect_min_size.y = graph_height
	graph.max_points = history
	graph.background_color = background_color
	graph.graph_color = graph_color
	graph.plot_graph = plot_graphs
	graph.unit = unit
	graph.normalize_units = normalize_units

	add_child(graph)
	_graphs.push_back(graph)
