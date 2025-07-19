extends Node2D

@onready var text_location = $"Text location"
@onready var return_btn = $ReturnButton
@onready var parent = $".."
@onready var pieces = $"..".pieces

var label
var reward

@export var label_group:String
@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_tree().get_first_node_in_group(label_group)
	label.resize_self(text_location.texture.get_size())
	label.position_self(parent.position + self.position + text_location.position)
	
	change_text(56, 57)
	

func change_text(id_1, id_2):
	var text = "[center][color="+Style.primary_color.to_html(false)+"][b][font_size=32]%s[/font_size][/b]\n" % TextManager.get_text_by_id(id_1)
	text += "[font_size=24]%s[/font_size][/color][/center]" % TextManager.get_text_by_id(id_2)
	
	label.text.text = text

func do_show():
	self.visible = true
	label.visible = true
	return_btn.do_show()
	

func dont_show():
	self.visible = false
	label.visible = false
	return_btn.dont_show()

func focus():
	return_btn.focus()

func unfocus():
	return_btn.unfocus()


