class_name PushZone
extends CameraControllerBase


@export var pushbox_top_left:Vector2 = Vector2(-10, -10)
@export var pushbox_bottom_right:Vector2 = Vector2(10, 10)
@export var speedup_top_left:Vector2 = Vector2(-5, -5)
@export var speedup_bottom_right:Vector2 = Vector2(5, 5)


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	
	#boundary checks
	
	#player is left of bounds if diff is negative
	var diff_between_left_edges = tpos.x - (cpos.x + pushbox_top_left.x)
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	#player is right of bounds if diff is positive
	var diff_between_right_edges = tpos.x - (cpos.x + pushbox_bottom_right.x)
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	#player is BELOW bounds if diff is positive
	var diff_between_bottom_edges = tpos.z - (cpos.z + pushbox_bottom_right.y)
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
	#player is ABOVE bounds if diff is negative
	var diff_between_top_edges = tpos.z - (cpos.z + pushbox_top_left.y)
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
		
	super(delta)
	


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var p_left:float = pushbox_top_left.x
	var p_right:float = pushbox_bottom_right.x
	var p_top:float = pushbox_top_left.y
	var p_bottom:float = pushbox_bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(p_right, 0, p_top))
	immediate_mesh.surface_add_vertex(Vector3(p_right, 0, p_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(p_right, 0, p_bottom))
	immediate_mesh.surface_add_vertex(Vector3(p_left, 0, p_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(p_left, 0, p_bottom))
	immediate_mesh.surface_add_vertex(Vector3(p_left, 0, p_top))
	
	immediate_mesh.surface_add_vertex(Vector3(p_left, 0, p_top))
	immediate_mesh.surface_add_vertex(Vector3(p_right, 0, p_top))
	immediate_mesh.surface_end()
	
	var s_left:float = speedup_top_left.x
	var s_right:float = speedup_bottom_right.x
	var s_top:float = speedup_top_left.y
	var s_bottom:float = speedup_bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(s_right, 0, s_top))
	immediate_mesh.surface_add_vertex(Vector3(s_right, 0, s_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(s_right, 0, s_bottom))
	immediate_mesh.surface_add_vertex(Vector3(s_left, 0, s_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(s_left, 0, s_bottom))
	immediate_mesh.surface_add_vertex(Vector3(s_left, 0, s_top))
	
	immediate_mesh.surface_add_vertex(Vector3(s_left, 0, s_top))
	immediate_mesh.surface_add_vertex(Vector3(s_right, 0, s_top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
