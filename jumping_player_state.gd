class_name JumpingPlayerState extends PlayerMovementState

@export var SPEED: float = 5.0
@export var ACCELORATION : float = 0.1
@export var DECELORATION : float = 0.25
@export var JUMP_VELOCITY : float = 4.5
@export_range(0.5, 1.0, 0.01) var INPUT_MULTIPLIER : float = 0.85


func enter() -> void:
	PLAYER.velocity.y += JUMP_VELOCITY
	ANIMATION.play("HeadlessAnimations/JumpHeadless")
	await ANIMATION.animation_finished
	ANIMATION.play("HeadlessAnimations/FallingHeadless")

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED * INPUT_MULTIPLIER, ACCELORATION, DECELORATION)
	PLAYER.update_velocity()

	if PLAYER.is_on_floor():
		ANIMATION.play("HeadlessAnimations/LandHeadless")
		transition.emit("IdlePlayerState")
