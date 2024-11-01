class_name PushZone
extends CameraControllerBase

@export var push_ratio:float = 0.5
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
	
	
	#is the player touching any of the 4 edges of the outer push square?
	var is_left_push:bool
	var is_right_push:bool
	var is_below_push:bool
	var is_above_push:bool
	#is the player beyond any of the 4 edges of the inner speedup square?
	var is_left_speedup:bool
	var is_right_speedup:bool
	var is_below_speedup:bool
	var is_above_speedup:bool
	
	#boundary checks and boolean definitions for this frame
	#player is left of bounds if diff is negative
	var diff_push_left = tpos.x - (cpos.x + pushbox_top_left.x)
	is_left_push = diff_push_left < 0
	if is_left_push:
		global_position.x += diff_push_left
	#player is right of bounds if diff is positive
	var diff_push_right = tpos.x - (cpos.x + pushbox_bottom_right.x)
	is_right_push = diff_push_right > 0
	if is_right_push:
		global_position.x += diff_push_right
	#player is BELOW bounds if diff is positive
	var diff_push_bottom = tpos.z - (cpos.z + pushbox_bottom_right.y)
	is_below_push = diff_push_bottom > 0
	if is_below_push:
		global_position.z += diff_push_bottom
	#player is ABOVE bounds if diff is negative
	var diff_push_top = tpos.z - (cpos.z + pushbox_top_left.y)
	is_above_push = diff_push_top < 0
	if is_above_push:
		global_position.z += diff_push_top
		
	#check if we are in speedup zone ranges, between the inner and outer squares
	var diff_speedup_left = tpos.x - (cpos.x + speedup_top_left.x)
	is_left_speedup = diff_speedup_left < 0
	var diff_speedup_right = tpos.x - (cpos.x + speedup_bottom_right.x)
	is_right_speedup = diff_speedup_right > 0
	var diff_speedup_bottom = tpos.z - (cpos.z + speedup_bottom_right.y)
	is_below_speedup = diff_speedup_bottom > 0
	var diff_speedup_top = tpos.z - (cpos.z + speedup_top_left.y)
	is_above_speedup = diff_speedup_top < 0
	
	#y-axis speedup zones dont affect x-axis movement and vice versa (mentioned in Lecture 10-24)
	if (!is_above_push && !is_below_push):
		if (is_above_speedup && target.velocity.z < 0):
			global_position.z += target.velocity.z * push_ratio * delta
		if (is_below_speedup && target.velocity.z > 0):
			global_position.z += target.velocity.z * push_ratio * delta
	if (!is_left_push && !is_right_push):
		if (is_left_speedup && target.velocity.x < 0):
			global_position.x += target.velocity.x * push_ratio * delta
		if (is_right_speedup && target.velocity.x > 0):
			global_position.x += target.velocity.x * push_ratio * delta
	
		
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
