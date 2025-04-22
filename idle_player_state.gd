class_name IdlePlayerState

extends PlayerMovementState

@export var SPEED: float = 5.0
@export var ACCELORATION : float = 0.1
@export var DECELORATION : float = 0.25

func enter() -> void:
	if ANIMATION.is_playing() and ANIMATION.current_animation == "HeadlessAnimations/JumpEnd":
		await ANIMATION.animation_finished
		ANIMATION.pause()
		ANIMATION.play("HeadlessAnimations/IdleHeadless")
	else:
		ANIMATION.pause()
		ANIMATION.play("HeadlessAnimations/IdleHeadless")

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELORATION, DECELORATION)
	PLAYER.update_velocity()
	
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	if PLAYER.computer_mode:
		transition.emit("ComputerPlayerState")
