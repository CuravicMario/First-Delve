extends Node2D
class_name OptionsPanel

@onready var children = self.get_children()

@export var first_element:Node
@export var TAB:Node

func do_show():
	self.visible = true
	TAB.underline.visible = true
	for i in children:
		i.do_show()

func dont_show():
	self.visible = false
	TAB.underline.visible = false
	for i in children:
		i.dont_show()
