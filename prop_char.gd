extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var mesh = $MeshInstance3D

@export var grabbed = false
@export var target = Vector3.ZERO
@export var speed = 5
@export var gravity = -5



func is_grabbed(boolean):
	grabbed = boolean
	
func set_target(hand_position):
	target = hand_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _physics_process(delta: float) -> void:
	if grabbed:
		#look_at(target)
		global_position = global_position.slerp(target, .2)
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
	move_and_slide()
