extends RigidBody3D

@onready var mesh = $MeshInstance3D

@export var grabbed = false
@export var target = Vector3.ZERO
@export var speed = 5
@export var gravity = -5

@onready var shapecast = $ShapeCast3D



func is_grabbed(boolean):
	
	grabbed = boolean
	
func set_target(hand_position):
	target = hand_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if grabbed:
		#look_at(target)
		global_position = global_position.slerp(target, .2)
