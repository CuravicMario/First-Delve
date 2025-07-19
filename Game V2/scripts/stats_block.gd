extends Sprite2D

var in_focus = false
var label

@onready var hover = $Hover
@onready var hover_fill = $Hover/Fill
@onready var hover_border = $Hover_border


@export var parent:Node
@export var label_group:String
@export var text_id:int
@export var show_hover:bool = true
@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	
	label = get_tree().get_first_node_in_group(label_group)
	label.resize_self(Vector2(92,60))
	label.position_self(parent.position + self.position + hover.position)
	label.text.get_theme_stylebox("normal").bg_color = Style.secondery_color
	
	label.text.text = "[color="+Style.primary_color.to_html(false)+"][font_size=18]%s[/font_size][/color]" % "This stat determens the ammount of damege an attack deals."
	label.visible = false
	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func adjust_text_placement(adjust_ammount):
	label.position_self(parent.position + self.position + hover.position + adjust_ammount)

func focus():
	if show_hover:
		label.text.text = "[color="+Style.primary_color.to_html(false)+"][font_size=18]%s[/font_size][/color]" % TextManager.get_text_by_id(text_id)
		label.position_self(parent.position + self.position + hover.position)
		hover.visible = true
		label.visible = true
		hover_border.visible = true
	in_focus = true

func unfocus():
	if show_hover:
		hover.visible = false
		label.visible = false
		hover_border.visible = false
	in_focus = false


func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input and !Global.tutorial:
		
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input and !Global.tutorial:
		
		unfocus()
