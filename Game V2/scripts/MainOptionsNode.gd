extends Node2D

@onready var starting_focus = $"../Tabs/Graphics"
@onready var tabs = $"../Tabs"


func _ready():
	Global.focus_points = starting_focus
	
	if Global.keyboard_input or Style.default_keyboard:
		Global.keyboard_input = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Global.current_focus = Global.focus_points
		Global.current_focus.focus()
