class_name ComputerComponent extends Node

var parent
@export var camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	parent.ready.connect(connect_parent)

func connect_parent() -> void:
	parent.connect("interacted", Callable(self, "toggle_camera"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_camera() -> void:
	camera.set_current(!camera.is_current())
	Global.player.computer_mode = camera.is_current()
	
