extends Node2D


@onready var frame = $TutorialBox
@onready var fill = $Fill
@onready var btns = [$MainMenu, $Exit, $Resume]
@onready var settings_btn = $"../SettingsBtn"
@onready var right_blocker = $RightBlocker


# Called when the node enters the scene tree for the first time.
func _ready():
	
	fill.scale = frame.get_used_rect().size * frame.tile_set.tile_size.x -  Vector2i(2,2)	
	
	for i in btns:
		i.dont_show()
	
	frame.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	frame.material.set_shader_parameter("replace_color_1", Style.primary_color)
	frame.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	frame.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	fill.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	fill.material.set_shader_parameter("replace_color_1", Style.primary_color)
	fill.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	fill.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	


func pause():
	right_blocker.do_show()
	self.visible = true
	for i in btns:
		i.do_show()
	
	if Global.keyboard_input:
		Global.current_focus.unfocus()
		Global.current_focus = btns[2]
		Global.current_focus.focus()
	
	get_tree().paused = true

func unpause():
	right_blocker.dont_show()
	self.visible = false
	for i in btns:
		i.dont_show()
	
	get_tree().paused = false
	
	if Global.keyboard_input:
		Global.current_focus.unfocus()
		Global.current_focus = settings_btn
		Global.current_focus.focus()




