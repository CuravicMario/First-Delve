extends Sprite2D
var in_focus = false
var label
var color

enum ARROW_TYPE {
	left,
	right
}

@onready var hover_border = $Hover_border
@onready var palette = $".."


@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node
@export var BAR_CONTROLED:Node
@export var DIRECTION:ARROW_TYPE


func _ready():	
	self.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	self.material.set_shader_parameter("replace_color_1", Style.primary_color)
	self.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	self.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)

func _physics_process(delta):
	if in_focus:
		if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact"):
			AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_SELECT)
			match DIRECTION:
				ARROW_TYPE.right:
					BAR_CONTROLED.rise()
				ARROW_TYPE.left:
					BAR_CONTROLED.lower()

func focus():
	AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_HOVER)
	hover_border.visible = true
	in_focus = true

func unfocus():
	hover_border.visible = false
	in_focus = false


func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input:
		
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input:
		
		unfocus()

