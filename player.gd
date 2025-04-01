extends CharacterBody3D

var speed

var obj = null
var last = Vector3.ZERO

const SPRINT_SPEED = 8.0
const WALK_SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.001

const BOB_FREQ =2.0
const BOB_AMP = 0.04
var t_bob = 0.0

var held_object = Object
var in_hand = false

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var hand = $Head/Camera3D/HoldPosition


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		$Model.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-55), deg_to_rad(60))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			$Model/AnimationPlayer.play("Walking")
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			$Model/AnimationPlayer.play("Idle")
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.x * speed, delta * 2.0)
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	var object = raycast.get_collider()
	
	if Input.is_action_pressed("interact"):
		if obj == null:
			var collider = raycast.get_collider()
			if collider != null:
				if collider.is_in_group("Pickable"):
					obj = collider
	
		if obj != null:
			obj.is_grabbed(true)
			obj.set_target(hand.global_position)
			#last = obj.global_position
			#obj.position = hand.global_position
			if obj.is_class("RigidBody3D"):
				obj.linear_velocity = Vector3.ZERO
	else:
		if obj != null:
			obj.is_grabbed(false)
			obj.set_target(Vector3.ZERO)
			#if obj.is_class("RigidBody3D"):
				#var velocity = obj.position - last
				#obj.linear_velocity = velocity * 2
		obj = null

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos
