class_name SprintingPlayerState
extends PlayerMovementState

@export var SPEED: float = 8.0
@export var ACCELORATION : float = 0.2
@export var DECELORATION : float = 0.3
@export var TOP_ANIM_SPEED : float = 1.6

func enter() -> void:
	if ANIMATION.is_playing() and ANIMATION.current_animation == "HeadlessAnimations/JumpEnd":
		await ANIMATION.animation_finished
		ANIMATION.play("HeadlessAnimations/WalkingHeadless", 0.5, 1.0)
	else:
		ANIMATION.play("HeadlessAnimations/WalkingHeadless", 0.5, 1.0)
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELORATION, DECELORATION)
	PLAYER.update_velocity()
	set_animation_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_released("sprint"):
		transition.emit("WalkingPlayerState")
		
	if PLAYER.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
	
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")	
	
func set_animation_speed(speed):
	var alpha = remap(speed, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
