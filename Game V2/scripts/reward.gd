extends Node2D

@onready var text_location = $"Text location"
@onready var reward_location = $"Reward position"
@onready var take_btn = $TakeBtn
@onready var parent = $".."
@onready var pieces = $"..".pieces

var label
var reward

@export var label_group:String
@export var unclaimed_equipment_pos:Node
@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_tree().get_first_node_in_group(label_group)
	label.resize_self(text_location.texture.get_size())
	label.position_self(parent.position + self.position + text_location.position)
	
	var text = "[center][color="+Style.primary_color.to_html(false)+"][b][font_size=32]%s[/font_size][/b]\n" % TextManager.get_text_by_id(8)
	text += "[font_size=24]%s[/font_size][/color][/center]" % TextManager.get_text_by_id(9)
	
	label.text.text = text
	
	reward_location.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	reward_location.material.set_shader_parameter("replace_color_1", Style.primary_color)
	reward_location.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	reward_location.material.set_shader_parameter("replace_color_2", Style.secondery_color)

func spawn_reward(id):
	take_btn.taken = false
	
	
	var temp_reward = load(Global.get_by_id(Global.equipment_db, id)["path"]).instantiate()
	temp_reward.id = id
	temp_reward.rarity = Global.get_by_id(Global.equipment_db, temp_reward.id)["rarity"]
	temp_reward.asign_stats()
	unclaimed_equipment_pos.add_child(temp_reward)
	
	temp_reward.position = parent.position + self.position + reward_location.position
	reward = temp_reward
	pass

func clear_uncolected_reward():
	if unclaimed_equipment_pos.get_child_count() > 0:
		for i in unclaimed_equipment_pos.get_children():
			i.queue_free()

func do_show(id):
	self.visible = true
	label.visible = true
	take_btn.do_show()
	
	spawn_reward(id)

func dont_show():
	clear_uncolected_reward()
	self.visible = false
	label.visible = false
	take_btn.dont_show()

func focus():
	reward.focus()

func unfocus():
	reward.unfocus()


