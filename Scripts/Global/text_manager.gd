extends Node

var text_db

var lang = "eng"

var stats_icons = ["res://Game V2/Sprites/info icon hp.png", "res://Game V2/Sprites/info icon armor.png", "res://Game V2/Sprites/info icon atk speed.png", "res://Game V2/Sprites/info icon atk.png", "res://Game V2/Sprites/info icon crit chance.png", "res://Game V2/Sprites/info icon dodge.png", "res://Game V2/Sprites/info icon gold.png", "res://Game V2/Sprites/info icon life steal.png", "res://Game V2/Sprites/info icon gold.png"]

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = "res://Game V2/Databases/text.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	text_db = JSON.parse_string(json_as_text)


func get_text_by_id(id):
	return text_db[id - 1][lang]

func get_text_by_tag(_tag):
	for i in text_db:
		if i["tag"] == _tag:
			return i[lang]

func edit_text(text, gold, dmg, hp, armor, rcg):
	text = text.replace("\\n", "\n")
	text = text.replace("%gold", str(gold))
	text = text.replace("%dmg",  str(dmg))
	text = text.replace("%hp",  str(hp))
	text = text.replace("%arm",  str(armor))
	text = text.replace("%rcg",  str(rcg))
	
	return text

func equipment_description(equipment_id):
	var equipment = Global.get_by_id(Global.equipment_db, equipment_id)
	var text = get_text_by_id(equipment["description"])
	
	text = text.replace("\\n", "\n")
	#Replace with stats
	text = text.replace("%hp", str(equipment["hp"]))
	text = text.replace("%atk", str(equipment["atk"]))
	text = text.replace("%speed", str(equipment["atkspeed"]*100)+"%")
	text = text.replace("%crit", str(equipment["crit"]))
	text = text.replace("%armor", str(equipment["armor"]))
	text = text.replace("%lifesteal", str(equipment["lifesteal"]))
	text = text.replace("%dodge", str(equipment["dodge"])+"%")
	
	#replace with img	
	text = text.replace("%img_hp", "[img=32 color="+Style.primary_color.to_html(false)+"]" + stats_icons[0] + "[/img]")
	text = text.replace("%img_atk", "[img=32 color="+Style.primary_color.to_html(false)+"]" + stats_icons[3] + "[/img]")
	text = text.replace("%img_speed", "[img=32 color="+Style.primary_color.to_html(false)+"]" + stats_icons[2] + "[/img]")
	text = text.replace("%img_crit", "[img=32 color="+Style.primary_color.to_html(false)+"]" + stats_icons[4] + "[/img]")
	text = text.replace("%img_armor", "[img=32 color="+Style.primary_color.to_html(false)+"]" + stats_icons[1] + "[/img]")
	text = text.replace("%img_lifesteal", "[img=32 color="+Style.primary_color.to_html(false)+"]" + stats_icons[7] + "[/img]")
	text = text.replace("%img_dodge", "[img=32 color="+Style.primary_color.to_html(false)+"]" + stats_icons[5] + "[/img]")
	text = text.replace("%img_gold", "[img=32 color="+Style.primary_color.to_html(false)+"]" + stats_icons[8] + "[/img]")
	
	
	return text


func set_lang(is_eng):
	if is_eng:
		lang = "eng"
	else:
		lang = "hr" 
