class_name ContextComponent
extends CenterContainer

@export var icon : TextureRect
@export var context : Label
@export var default_icon : Texture2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MessageBus.interaction_focused.connect(update)
	MessageBus.interaction_unfocused.connect(reset)
	reset()

func reset() -> void:
	icon.texture = null
	context.text = ""
	
func update(my_text, image = default_icon, override = false) -> void:
	context.text = my_text
	if override:
		icon.texture = image
	else:
		icon.texture = default_icon
	
