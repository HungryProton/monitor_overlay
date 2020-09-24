extends VBoxContainer


export var background_color := Color(0.0, 0.0, 0.0, 0.5)
export var plot_graphs := true
export var graph_color := Color.orange
export var history := 100
export var graph_height := 50

export var fps := true
export var process := false
export var physics_process := false
export var static_memory := false
export var dynamic_memory := false
export var max_static_memory := false
export var max_dynamic_memory := false
export var max_message_buffer := false
export var objects := false
export var resources := false
export var nodes := false
export var orphan_nodes := false
export var objects_drawn := false
export var vertices_drawn := false
export var material_changes := false
export var shader_changes := false
export var surface_changes := false
export var draw_calls_3d := false
export var items_2d := false
export var draw_calls_2d := false
export var video_memory := false
export var texture_memory := false
export var vertex_memory := false
export var max_video_memory := false
export var active_objects_2d := false
export var collision_pairs_2d := false
export var islands_2d := false
export var active_objects_3d := false
export var collision_pairs_3d := false
export var islands_3d := false
export var audio_output_latency := false


var _timer: Timer
var _font: DynamicFont = load("res://addons/monitor_overlay/font/overlay_font.tres")
var _debug_graph = load("res://addons/monitor_overlay/monitor_overlay_debug_graph.gd")
var _graphs := []


func _ready():
	if rect_min_size.x == 0:
		rect_min_size.x = 300
		
	if fps:
		_create_graph_for(Performance.TIME_FPS, "FPS")
		
	if process:
		_create_graph_for(Performance.TIME_PROCESS, "Process")
		
	if physics_process:
		_create_graph_for(Performance.TIME_PHYSICS_PROCESS, "Physics Process")
		
	if static_memory:
		_create_graph_for(Performance.MEMORY_STATIC, "Static Memory")
		
	if dynamic_memory:
		_create_graph_for(Performance.MEMORY_DYNAMIC, "Dynamic Memory")
		
	if max_static_memory:
		_create_graph_for(Performance.MEMORY_STATIC_MAX, "Max Static Memory")
	
	if max_dynamic_memory:
		_create_graph_for(Performance.MEMORY_DYNAMIC_MAX, "Max Dynamic Memory")
	
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
		_create_graph_for(Performance.RENDER_OBJECTS_IN_FRAME, "Objects Drawn")
	
	if vertices_drawn:
		_create_graph_for(Performance.RENDER_VERTICES_IN_FRAME, "Vertices Drawn")
	
	if material_changes:
		_create_graph_for(Performance.RENDER_MATERIAL_CHANGES_IN_FRAME, "Material Changes")
	
	if shader_changes:
		_create_graph_for(Performance.RENDER_SHADER_CHANGES_IN_FRAME, "Shader Changes")
	
	if surface_changes:
		_create_graph_for(Performance.RENDER_SURFACE_CHANGES_IN_FRAME, "Surface Changes")
	
	if draw_calls_3d:
		_create_graph_for(Performance.RENDER_DRAW_CALLS_IN_FRAME, "3D Draw Calls")
	
	if items_2d:
		_create_graph_for(Performance.RENDER_2D_ITEMS_IN_FRAME, "2D Items")
	
	if draw_calls_2d:
		_create_graph_for(Performance.RENDER_2D_DRAW_CALLS_IN_FRAME, "2D Draw calls")
	
	if video_memory:
		_create_graph_for(Performance.RENDER_VIDEO_MEM_USED, "Video Memory")
	
	if texture_memory:
		_create_graph_for(Performance.RENDER_TEXTURE_MEM_USED, "Texture Memory")
	
	if vertex_memory:
		_create_graph_for(Performance.RENDER_VERTEX_MEM_USED, "Vertex Memory")
	
	if max_video_memory:
		_create_graph_for(Performance.RENDER_USAGE_VIDEO_MEM_TOTAL, "Max Video Memory")
	
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
		_create_graph_for(Performance.AUDIO_OUTPUT_LATENCY, "Audio Output Latency")


func _process(_delta) -> void:
	for item in _graphs:
		item.update()


func _create_graph_for(monitor: int, name: String) -> void:
	var graph = _debug_graph.new()
	graph.monitor = monitor
	graph.monitor_name = name
	graph.font = _font
	graph.rect_min_size.y = graph_height
	graph.max_points = history
	graph.background_color = background_color
	graph.graph_color = graph_color
	graph.plot_graph = plot_graphs

	add_child(graph)
	_graphs.append(graph)
