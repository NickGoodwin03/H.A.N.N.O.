extends Node3D

# Used for checking if the mouse is inside the Area3D.
var is_mouse_inside = false
# The last processed input touch/mouse event. To calculate relative movement.
var last_event_pos2D = null
# The time of the last event in seconds since engine start.
var last_event_time: float = -1.0

@onready var node_viewport = $SubViewport
@onready var node_quad = $MeshInstance3D
@onready var node_area = $MeshInstance3D/Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	node_area.mouse_entered.connect(_mouse_entered_area)
	node_area.mouse_exited.connect(_mouse_exited_area)
	node_area.input_event.connect(_mouse_input_event)

func _mouse_entered_area():
	is_mouse_inside = true
	#print("Mouse Entered")
	
func _mouse_exited_area():
	is_mouse_inside = false
	#print("Mouse Exited")
	
func _unhandled_input(event):
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion]:
		if is_instance_of(event, mouse_event):
			return
	node_viewport.push_input(event)
	
func _mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int):
	var mesh_size = node_quad.mesh.size
		
		
	var event_pos3D = event_position
		
	var now: float = Time.get_ticks_msec() / 1000.0
		
	event_pos3D = node_quad.global_transform.affine_inverse() * event_pos3D
		
	var event_pos2D: Vector2 = Vector2()
		
	if is_mouse_inside:
		event_pos2D = Vector2(event_pos3D.x, -event_pos3D.y)
			
		# Right now the event position's range is the following: (-quad_size/2) -> (quad_size/2)
		# We need to convert it into the following range: -0.5 -> 0.5
		event_pos2D.x = event_pos2D.x / mesh_size.x
		event_pos2D.y = event_pos2D.y / mesh_size.y
		# Then we need to convert it into the following range: 0 -> 1
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5
			
		# Finally, we convert the position to the following range: 0 -> viewport.size
		event_pos2D.x *= node_viewport.size.x
		event_pos2D.y *= node_viewport.size.y
		# We need to do these conversions so the event's position is in the viewport's coordinate system.
		
	elif last_event_pos2D != null:
		event_pos2D = last_event_pos2D
		
	event.position = event_pos2D
	if event is InputEventMouse:
		event.global_position = event_pos2D
			
	if event is InputEventMouseMotion:
		if last_event_pos2D == null:
			event.relative = Vector2(0, 0)
				
		else:
			event.relative = event_pos2D - last_event_pos2D
			event.velocity = event.relative / (now - last_event_time)
				
	last_event_pos2D = event_pos2D
	
	last_event_time = now
	
	node_viewport.push_input(event)
