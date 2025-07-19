extends Sprite2D

@export var info_group_name:String

@onready var info_name = $Name
@onready var hp_bar = $"HP Bar"
@onready var hp_bar_fill = $"HP Bar/TextureProgressBar"
@onready var stats = $Stats
@onready var gold = $Gold
@onready var default_info = $"../PlayerSprite"

var info_labels

var is_default_focus = true

# Called when the node enters the scene tree for the first time.
func _ready():
	info_labels = get_tree().get_nodes_in_group(info_group_name)
	place_labels()
	
	hp_bar_fill.self_modulate = Style.hp_color
	
	self.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	self.material.set_shader_parameter("replace_color_1", Style.primary_color)
	self.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	self.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	info_name.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	info_name.material.set_shader_parameter("replace_color_1", Style.primary_color)
	info_name.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	info_name.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	hp_bar.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hp_bar.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hp_bar.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hp_bar.material.set_shader_parameter("replace_color_2", Style.secondery_color)

func place_labels():
	info_labels[0].resize_self(info_name.texture.get_size())
	info_labels[0].position_self(self.position + info_name.position) 
	
	info_labels[1].resize_self(hp_bar.texture.get_size())
	info_labels[1].position_self(self.position + hp_bar.position) 
	
	info_labels[2].resize_self(gold.texture.get_size())
	info_labels[2].position_self(self.position + gold.position) 
	
	var label_pos = 3
	for i in stats.get_children():
		info_labels[label_pos].resize_self(i.texture.get_size())
		info_labels[label_pos].position_self(self.position + i.position)
		info_labels[label_pos].position += Vector2(0, info_labels[label_pos].size.y/4.0)
		label_pos += 1

func update_info(is_player, stats_dict, current_hp):
	if is_player:
		info_labels[0].text = stats_dict["name"]
		info_labels[0].modulate = Style.primary_color
		
		info_labels[1].text = str(current_hp) + " / " + str(stats_dict["hp"])
		info_labels[1].modulate = Style.primary_color
		hp_bar_fill.max_value = stats_dict["hp"]
		hp_bar_fill.value = current_hp
		
		info_labels[2].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=38 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon gold.png[/img]" + str(stats_dict["gold"]) + "[/center][/font_size][/b][/color]"
				
		info_labels[3].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon atk.png[/img]:" + str(stats_dict["atk"]) + "[/center][/font_size][/b][/color]"
		info_labels[4].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon atk speed.png[/img]:" + str(stats_dict["atkspeed"]) + "[/center][/font_size][/b][/color]"
		info_labels[5].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon armor.png[/img]:" + str(stats_dict["armor"]) + "[/center][/font_size][/b][/color]"
		info_labels[6].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon life steal.png[/img]:" + str(stats_dict["lifesteal"]) + "%[/center][/font_size][/b][/color]"
		info_labels[7].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon crit chance.png[/img]:" + str(stats_dict["crit"]) + "%[/center][/font_size][/b][/color]"
		info_labels[8].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon dodge.png[/img]:" + str(stats_dict["dodge"]) + "%[/center][/font_size][/b][/color]"
	else:
		info_labels[0].text = stats_dict["name"]
		info_labels[0].modulate = Style.primary_color
		
		info_labels[1].text = str(current_hp) + " / " + str(stats_dict["hp"])
		info_labels[1].modulate = Style.primary_color
		hp_bar_fill.max_value = stats_dict["hp"]
		hp_bar_fill.value = current_hp
		
		info_labels[2].text = ""
				
		info_labels[3].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon atk.png[/img]:" + str(stats_dict["atk"]) + "[/center][/font_size][/b][/color]"
		info_labels[4].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon atk speed.png[/img]:" + str(stats_dict["atkspeed"]) + "[/center][/font_size][/b][/color]"
		info_labels[5].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon armor.png[/img]:" + str(stats_dict["armor"]) + "[/center][/font_size][/b][/color]"
		info_labels[6].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon life steal.png[/img]:" + str(stats_dict["lifesteal"]) + "%[/center][/font_size][/b][/color]"
		info_labels[7].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon crit chance.png[/img]:" + str(stats_dict["crit"]) + "%[/center][/font_size][/b][/color]"
		info_labels[8].text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=64 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon dodge.png[/img]:" + str(stats_dict["dodge"]) + "%[/center][/font_size][/b][/color]"

func return_to_default_info():
	is_default_focus = true
	update_info(true, default_info.player_stats, default_info.current_hp)













