extends Node2D

@onready var start_btn = $"../StartGame"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.focus_points = start_btn
	if Global.keyboard_input or Style.default_keyboard:
		Global.keyboard_input = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Global.current_focus = Global.focus_points
		Global.current_focus.focus()

