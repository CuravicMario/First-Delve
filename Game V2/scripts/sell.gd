extends TileMap


var label

@onready var parrent_node = $".."
@onready var area = $Area2D

@export var label_group:String

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_tree().get_first_node_in_group(label_group)
	label.resize_self(Vector2(60,60))
	label.position_self(parrent_node.position + self.position + area.position)
	
	label.text.text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=28]SELL\n("+str(InputMap.action_get_events("sell")[0].as_text_physical_keycode())+")[/font_size][/b][/color]"
	var actions = InputMap.get_actions()
	var sell_action = actions.find("sell")
	print(str(InputMap.action_get_events("sell")[0].as_text_physical_keycode()))
	
	
	
	self.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	self.material.set_shader_parameter("replace_color_1", Style.primary_color)
	self.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	self.material.set_shader_parameter("replace_color_2", Style.secondery_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
