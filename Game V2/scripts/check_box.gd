extends Node2D
class_name MainCheckBox

var ticked = false
var in_focus = false

enum CHECKBOX_TYPE {
	fullscreen,
	keyboard
}

@onready var hover_border = $Hover_border
@onready var border = $Border
@onready var checked = $Checked
@onready var palette = $".."


@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node
@export var checkbox_type:CHECKBOX_TYPE


func _ready():	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	match checkbox_type:
		CHECKBOX_TYPE.fullscreen:
			if Style.fullscreen:
				ticked = true
				checked.visible = true
			else:
				ticked = false
				checked.visible = false
		CHECKBOX_TYPE.keyboard:
			if Style.default_keyboard:
				ticked = true
				checked.visible = true
			else:
				ticked = false
				checked.visible = false

func _physics_process(delta):
	if in_focus:
		if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact"):
			AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_SELECT)
			ticked = not ticked
			if ticked:
				checked.visible = true
			else:
				checked.visible = false

func do_show():
	visible = true

func dont_show():	
	visible = false


func focus():
	AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_HOVER)
	hover_border.visible = true
	border.visible = false
	in_focus = true

func unfocus():
	hover_border.visible = false
	border.visible = true
	in_focus = false


func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input:
		
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input:
		
		unfocus()

