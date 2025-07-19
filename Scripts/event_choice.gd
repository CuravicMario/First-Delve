extends Node2D
@export var text_group:String
@export var size:Vector2

@onready var fill = $Fill
@onready var border = $Border
var text
@onready var choice = $choice

var in_focus

# Called when the node enters the scene tree for the first time.
func _ready():
	fill.self_modulate = Style.primary_color
	border.self_modulate = Style.secondery_color
	
	#text.set_font_color(Style.secondery_color)
	#text.set_label_position(self.global_position, size)

func _process(delta):
	if in_focus:
		if (Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact")):
			choice.chosen()

func set_text(_label, _text):
	text = _label
	text.text = _text
	
	text.set_label_position(self.position, Vector2(118,28))
	text.set_font_color(Style.secondery_color)
	text.set_label_position(self.global_position, size)

func set_choice(_choice, _pieces):
	choice.set_script(load(_choice))
	choice.player_pieces = _pieces

func focus():
	border.self_modulate  = Style.primary_color
	fill.self_modulate = Style.secondery_color
	text.set_font_color(Style.primary_color)

func unfocus():
	border.self_modulate  = Style.secondery_color
	fill.self_modulate = Style.primary_color
	text.set_font_color(Style.secondery_color)


func _on_area_2d_mouse_entered():
	if not Global.is_dragging and !Global.keyboard_input and not Global.combat_end:
		in_focus = true
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and !Global.keyboard_input and not Global.combat_end:
		in_focus = false
		unfocus()
