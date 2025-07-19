extends Node2D

var event_id
var event_texts

@export var event_group_name:String

@onready var body_text = $"Event Text Body"
@onready var room_complete_btn = $"Room Complete"
@onready var choices = $Choices
@onready var border = $Border
@onready var reward = $Reward
@onready var pieces = $"../pieces"
@onready var lowest_elements = [$"Event Text Body",$Choices/Choice3,$"Room Complete"]
@onready var tutorial = $"../Tutorial"

@export var player:Node
@export var room_select:Node

func _ready():
	border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	border.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	event_texts = get_tree().get_nodes_in_group(event_group_name)
	

func activate(_event_id):
	construct_an_event(_event_id)
	self.visible = true
	show_event()
	pieces.UP_NEIGHBOUR = lowest_elements[0]
	for i in lowest_elements:
		i.DOWN_NEIGHBOUR = pieces
	if Global.in_tutorial:
		tutorial.open_tutorial()

func deactivate():
	room_complete_btn.dont_show()
	reward.dont_show()
	#body_text.dont_show()
	event_texts = get_tree().get_nodes_in_group(event_group_name)
	for i in event_texts:
		i.visible = false
	self.visible = false
	
	#print(event_texts)

func construct_an_event(id):
	event_id = id
	var event = Global.get_by_id(Global.event_db, id)
	
	event_texts[0].resize_self(body_text.texture.get_size())
	event_texts[0].position_self(self.position + body_text.position)
	
	var full_text = "[color="+Style.primary_color.to_html(false)+"][color="+Style.primary_color.to_html(false)+"][p margins=20,20,20,20][center][font_size=40]%s[/font_size]" % TextManager.get_text_by_id(Global.event_db[id - 1]["title"])
	full_text += "\n[img color="+Style.primary_color.to_html(false)+"]res://Sprites/tests/main menu/event_title_divider.png[/img][/center]"
	full_text += "[font_size=20]%s[/font_size][/p][/color]" % TextManager.get_text_by_id(Global.event_db[id - 1]["body"])
	
	event_texts[0].text.text  = full_text.replace("\\n", "\n")
	
	var choice_text1 = "[color="+Style.primary_color.to_html(false)+"][font_size=22]%s[/font_size][/color]" % TextManager.get_text_by_id(Global.event_db[id - 1]["choice1text"])
	var choice_text2 = "[color="+Style.primary_color.to_html(false)+"][font_size=22]%s[/font_size][/color]" % TextManager.get_text_by_id(Global.event_db[id - 1]["choice2text"])
	var choice_text3 = "[color="+Style.primary_color.to_html(false)+"][font_size=22]%s[/font_size][/color]" % TextManager.get_text_by_id(Global.event_db[id - 1]["choice3text"])
	var choice_texts = [choice_text1,choice_text2,choice_text3]
	
	var choices_array = choices.get_children()
	
	choices_array[0].choice_id  = Global.event_db[id - 1]["choice1"]
	choices_array[1].choice_id  = Global.event_db[id - 1]["choice2"]
	choices_array[2].choice_id  = Global.event_db[id - 1]["choice3"]
	
	for i in range (1,4):
		event_texts[i].resize_self(choices_array[i-1].texture.get_size())
		event_texts[i].position_self(self.position + choices_array[i-1].position)
		
		event_texts[i].text.text = choice_texts[i - 1]
	
	
	pass

func show_reward(reward_id):
	for i in event_texts:
		i.visible = false
	body_text.visible = false
	choices.visible = false
	
	border.visible = true
	reward.do_show(reward_id)
	room_complete_btn.do_show()
	
	pieces.UP_NEIGHBOUR = lowest_elements[2]
	if Global.keyboard_input:
		Global.current_focus.unfocus()
		Global.current_focus = pieces
		Global.current_focus.focus()
		if Global.in_sub_focus:
			pieces.active = false
			Global.in_sub_focus = false
			pieces.sub_focus.unfocus()
			pieces.sub_focus = null

func show_event():
	for i in event_texts:
		i.visible = true
	body_text.visible = true
	choices.visible = true
	
	border.visible = false
	reward.dont_show()
	room_complete_btn.dont_show()
	pieces.UP_NEIGHBOUR = lowest_elements[0]








