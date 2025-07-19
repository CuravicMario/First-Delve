extends Node2D

var currently_active = null

@onready var tabs = $"../Tabs"

@export var FIRST_ACTIVE:Node

func _ready():
	
	for i in get_children():
		i.dont_show()
	
	change_panel(FIRST_ACTIVE)

func change_panel(panel):
	if currently_active == null:
		panel.do_show()
		currently_active = panel
		change_neighbours(panel)
	elif not currently_active == panel:
		currently_active.dont_show()
		panel.do_show()
		currently_active = panel
		change_neighbours(panel)

func change_neighbours(panel):
	for i in tabs.get_children():
		i.RIGHT_NEIGHBOUR = panel.first_element

