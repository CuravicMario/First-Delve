extends Node2D

var in_focus = false

@onready var sprite = $Sprite2D
@onready var hover_border = $Hover_border
@onready var pause_panel = $"../Pause"

@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node


# Called when the node enters the scene tree for the first time.
func _ready():
	
	sprite.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	sprite.material.set_shader_parameter("replace_color_1", Style.primary_color)
	sprite.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	sprite.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_focus:
		if (Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact")):
			AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_SELECT)
			pause_panel.pause()

func focus():
	AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_HOVER)
	in_focus = true
	hover_border.visible = true

func unfocus():
	in_focus = false
	hover_border.visible = false





func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input:
		
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input:
		
		unfocus()
