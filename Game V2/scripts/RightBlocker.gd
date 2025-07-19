extends Marker2D

@export var label_group:String
@export var btn_real_pos:Vector2

var label

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_tree().get_first_node_in_group(label_group)
	label.resize_self(Vector2(68,188))
	label.text.get_theme_stylebox("normal").bg_color = Style.secondery_color
	label.position_self(btn_real_pos)
	label.text.text = ""


func dont_show():
	visible = false 
	label.visible = false

func do_show():
	visible = true 
	label.visible = true
