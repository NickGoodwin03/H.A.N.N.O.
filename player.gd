class_name Player
extends CharacterBody3D

###My player variables###
var speed
var obj = null
var last = Vector3.ZERO

const SPRINT_SPEED = 8.0
const WALK_SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.001
const ACCELERATION = 0.1
const DECELERATION = 0.45
@export var ANIMATIONPLAYER : AnimationPlayer

const BOB_FREQ =2.0
const BOB_AMP = 0.04
var t_bob = 0.0

var held_object = Object
var in_hand = false

var computer_mode = false

#@onready var CAMERA_CONTROLLER = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var hand = $Head/Camera3D/HoldPosition

###Tutorial Player variables###

@export var SPEED : float = 5.0
#@export var JUMP_VELOCITY : float = 4.5
@export var MOUSE_SENSITIVITY : float = 0.05
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Node3D
@export var CAMERA: Camera3D
@export var interact_distance : float = 2

var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3
var interact_cast_result

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Global.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY
	
	
		#if event is InputEventMouseMotion:
			#head.rotate_y(-event.relative.x * SENSITIVITY)
			#$Model.rotate_y(-event.relative.x * SENSITIVITY)
			#camera.rotate_x(-event.relative.y * SENSITIVITY)
			#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-55), deg_to_rad(60))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
	
	

func _update_camera(delta):
	# Rotates camera using euler rotation
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)

	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	CAMERA_CONTROLLER.rotation.z = 0.0

	_rotation_input = 0.0
	_tilt_input = 0.0
		

func _physics_process(delta: float) -> void:
	
	Global.debug.add_property("MovementSpeed", speed, 3)
	Global.debug.add_property("Velocity", velocity.length(), 4)
	
	_update_camera(delta)
	#interact_cast()
	
	#t_bob += delta * velocity.length() * float(is_on_floor())
	#camera.transform.origin = _headbob(t_bob)
	
	if Input.is_action_pressed("grab"):
		
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

	#if Input.is_action_just_pressed("interact"):
		#var collider = raycast.get_collider()
		#if collider != null:
			#print(collider.name)
			#if collider.is_in_group("Interactable"):
					#if collider.is_interacted():
						#collider.set_interacted(false)
						#camera.make_current()
						#computer_mode = false
						#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					#else:
						#collider.set_interacted(true)
						#computer_mode = true
						#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
						#
						#
	if Input.is_action_just_pressed("unlock_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		
	
	

#func _headbob(time) -> Vector3:
	#var pos = Vector3.ZERO
	#pos.y = sin(time * BOB_FREQ) * BOB_AMP
	#return pos

func update_gravity(delta) -> void:
		velocity.y -= gravity * delta
		
	
func update_input(speed: float, acceloration: float, deceloration: float) -> void:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#$Model/AnimationPlayer.play("Walking")
		velocity.x = lerp(velocity.x, direction.x * speed, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * speed, ACCELERATION)
	else:
		#$Model/AnimationPlayer.play("Idle")
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)
	#keep momentum in air
	#else:
		#velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		#velocity.z = lerp(velocity.z, direction.x * speed, delta * 2.0)
	
func update_velocity() -> void:
	move_and_slide()
