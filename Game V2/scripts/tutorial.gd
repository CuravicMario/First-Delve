extends Node2D


@onready var frame = $TutorialBox
@onready var fill = $Fill
@onready var next_arrow = $NextArrow
@onready var pieces = $"../pieces"
@onready var text_offset = $Marker2D

var step = 0
var part = 0
var label
var label_size = Vector2(204,120)
var current_part
var parts

@export var label_group:String
@export var combat_part:Array[int]
@export var reward_part:Array[int]
@export var room_select_part:Array[int]
@export var shop_part:Array[int]
@export var event_part:Array[int]
@export var boss_part:Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_tree().get_first_node_in_group(label_group)
	label.resize_self(label_size)
	label.text.get_theme_stylebox("normal").bg_color = Style.secondery_color
	label.visible = false
	
	parts = [combat_part, reward_part, shop_part, event_part, boss_part]
	
	fill.scale = frame.get_used_rect().size * frame.tile_set.tile_size.x -  Vector2i(2,2)
	
	frame.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	frame.material.set_shader_parameter("replace_color_1", Style.primary_color)
	frame.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	frame.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	fill.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	fill.material.set_shader_parameter("replace_color_1", Style.primary_color)
	fill.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	fill.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	if Global.in_tutorial:
		open_tutorial()

func start_tutorial():
	visible = true
	label.visible = true
	Global.tutorial = true
	
	label.position_self(self.position + text_offset.position)
	current_part = combat_part
	show_step(current_part[step])


func show_step(text_id):
	var text = TextManager.get_text_by_id(text_id)
	text = text.replace("\\n", "\n")
	text = text.replace("%sell", str(InputMap.action_get_events("sell")[0].as_text_physical_keycode()))
	text = text.replace("%inter", str(InputMap.action_get_events("interact")[0].as_text_physical_keycode()))
	text = text.replace("%kboard", str(InputMap.action_get_events("keyboard_mode")[0].as_text_physical_keycode()))
	
	label.text.text = "[font_size=20]%s[/font_size]" % text

func open_tutorial():
	print("OPEN")
	visible = true
	label.visible = true
	Global.tutorial = true
	
	if Global.keyboard_input or Style.default_keyboard:
		Global.current_focus.unfocus()
		Global.current_focus = next_arrow
		Global.current_focus.focus()
	
	label.position_self(self.position + text_offset.position)
	current_part = parts[part]
	show_step(current_part[step])

func next_step():
	step += 1
	
	if step == current_part.size():
		print("CLOSING TUTORIAL")
		close_tutorial()
		step = 0
		part += 1
		if part == parts.size():
			pass#Global.in_tutorial = false
		if Global.keyboard_input or Style.default_keyboard:
			Global.current_focus.unfocus()
			Global.current_focus = pieces
			Global.current_focus.focus()
	else:
		print("SELF OPENING")
		show_step(current_part[step])

func close_tutorial():
	visible = false
	label.visible = false
	Global.tutorial = false
	




