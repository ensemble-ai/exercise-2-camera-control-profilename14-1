class_name PositionLock
extends CameraControllerBase


const DRAW_LOGIC_SIZE:float = 5


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
	
	#check if the target has moved from the target lock camera.
	#horizontal (with top down view) check. Positive means target is right of us
	var diff_horizontally = (tpos.x - cpos.x)
	if abs(diff_horizontally) > 0:
		global_position.x += diff_horizontally
	#vertical (with top down view) check. Positive means target is below us
	var diff_vertically = (tpos.z - cpos.z)
	if abs(diff_vertically) > 0:
		global_position.z += diff_vertically
		
		
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -DRAW_LOGIC_SIZE / 2
	var right:float = DRAW_LOGIC_SIZE / 2
	var top:float = -DRAW_LOGIC_SIZE / 2
	var bottom:float = DRAW_LOGIC_SIZE / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, top))
	immediate_mesh.surface_end()
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))
	immediate_mesh.surface_end()
	

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
