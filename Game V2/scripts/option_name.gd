extends Node2D

var in_focus = false
var label

@onready var hover_border = $Hover_border


@export var parent:Node
@export var label_group:String
@export var text_id:int
@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node


func _ready():
	
	label = get_tree().get_first_node_in_group(label_group)
	label.resize_self(Vector2(208,16))
	label.position_self(self.position)
	label.modulate = Style.primary_color
	label.text = TextManager.get_text_by_id(text_id)
	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)

func focus():
	AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_HOVER)
	hover_border.visible = true
	in_focus = true

func unfocus():
	hover_border.visible = false
	in_focus = false

func do_show():
	visible = true
	label.visible = true

func dont_show():
	visible = false
	label.visible = false




func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input:
		
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input:
		
		unfocus()


