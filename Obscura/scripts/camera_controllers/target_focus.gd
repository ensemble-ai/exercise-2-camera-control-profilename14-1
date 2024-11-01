class_name TargetFocus
extends CameraControllerBase


const DRAW_LOGIC_SIZE:float = 5

@export var lead_speed:float = 1.5 #Ratio of player speed, 1 is equal
@export var catchup_delay_duration:float = 0.5
@export var catchup_speed:float = 20.0
@export var leash_distance:float = 10.0

var _catchup_active:bool = false
var _catchup_timer:float = 0

func _ready() -> void:
	super()
	position = target.position
	
#physics process is used to avoid fps dependency and jitteriness
func _physics_process(delta: float) -> void:
	
	if target.velocity.length() > 0:
		_catchup_active = false
		#Simply move the camera relative to (and faster than) player speed
		var lead_displacement:Vector3 = target.velocity * lead_speed * delta
		global_position += lead_displacement
	else:
		if (!_catchup_active and _catchup_timer <= 0):
			_catchup_timer = catchup_delay_duration
	
	var tpos = target.global_position
	var cpos = global_position
	
	#horizontal (with top down view) check. Positive means target is right of us
	var diff_horizontally = (tpos.x - cpos.x)
	#vertical (with top down view) check. Positive means target is below us
	var diff_vertically = (tpos.z - cpos.z)
	
	if _catchup_active:
		_follow_camera(diff_horizontally, diff_vertically, delta, catchup_speed)
	elif Vector2(diff_horizontally, diff_vertically).length() <= 0:
		_catchup_active = false
	
	#If we moved too far the last step, push the camera within leash range.
	if Vector2(diff_horizontally, diff_vertically).length() > leash_distance:
		_leash_camera(diff_horizontally, diff_vertically)

func _process(delta: float) -> void:
	if !current:
		return
	
	_process_timers(delta)
	
	if draw_camera_logic:
		draw_logic()
	
	super(delta)

#if camera is more than 10 units away, we scale the displacement to the leash distance.
func _leash_camera(diff_x: float, diff_z: float) -> void:
	var diff_normalized:Vector2 = Vector2(diff_x, diff_z).normalized()
	var new_displacement:Vector2 = diff_normalized * leash_distance
	global_position.x = target.global_position.x - new_displacement.x
	global_position.z = target.global_position.z - new_displacement.y

#This function simply moves the vector in a straight line toward the player
func _follow_camera(diff_x: float, diff_z: float, delta: float, speed: float) -> void:
	var diff_normalized:Vector2 = Vector2(diff_x, diff_z).normalized()
	var follow_step:Vector2 = diff_normalized * speed * delta
	
	#if our step is larger than the actual camera displacement, scale it down
	if follow_step.length() > Vector2(diff_x, diff_z).length():
		var overreach_factor:float = Vector2(diff_x, diff_z).length() / follow_step.length()
		follow_step *= overreach_factor
	
	global_position.x = global_position.x + follow_step.x
	global_position.z = global_position.z + follow_step.y

func _process_timers(delta : float) -> void:
	if (_catchup_timer > 0):
		_catchup_timer -= delta
		if (_catchup_timer <= 0):
			_catchup_active = true

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
