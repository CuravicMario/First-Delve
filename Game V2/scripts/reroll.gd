extends Sprite2D

var in_focus = false
var label
var reroll_price = 1

@onready var parent = $".."
@onready var gold = $Gold
@onready var hover_border = $Hover_border

@export var label_group:String
@export var player:Node
@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_tree().get_first_node_in_group(label_group)
	
	label.resize_self(gold.texture.get_size())
	label.position_self(parent.position + self.position + gold.position) 
	label.text.text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=38 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon gold.png[/img]" + str(reroll_price) + "[/center][/font_size][/b][/color]"
	
	self.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	self.material.set_shader_parameter("replace_color_1", Style.primary_color)
	self.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	self.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_focus:
		if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact"):
			if player.has_enough_gold(reroll_price):
				player.spend_gold(reroll_price)
				parent.stock_shop()


func focus():
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




func _on_gold_ready():
	pass
