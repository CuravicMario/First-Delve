extends Sprite2D


var id = 1
var room_type
var in_focus = false

@onready var parrent_node = $".."
@onready var icon = $Icon
@onready var hover_border = $HoverBorder

@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node

func _ready():
	self.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	self.material.set_shader_parameter("replace_color_1", Style.primary_color)
	self.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	self.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	icon.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	icon.material.set_shader_parameter("replace_color_1", Style.primary_color)
	icon.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	icon.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_focus:
		if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact"):
			parrent_node.move_room(room_type, id)

func focus():
	in_focus = true
	hover_border.visible = true

func unfocus():
	hover_border.visible = false
	in_focus = false

func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input:
		
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input:
		
		unfocus()
