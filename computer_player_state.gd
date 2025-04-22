class_name ComputerPlayerState 
extends PlayerMovementState

@export var SPEED: float = 0
@export var ACCELORATION : float = 0
@export var DECELORATION : float = 0

func enter() -> void:
	ANIMATION.pause()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELORATION, DECELORATION)
	PLAYER.update_velocity()
	

	if !PLAYER.computer_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		transition.emit("IdlePlayerState")
