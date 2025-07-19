extends Node
class_name Options

var font = "res://Fonts/Roboto-Black.ttf"

var default_primary_color
var default_secondery_color
var default_hp_color

var primary_color
var secondery_color
var hp_color

var palett = ["#ebe5ce","#2e3037", "#999999","#332288","#117733","#44AA99","#88CCEE","#DDCC77","#CC6677","#AA4499","#882255","#CC3311", "#EE7733"]

var map_indicators = {
	"player": Color.html("25562e"),
	"hover": Color.html("73bed3")
}

var fullscreen = false

var start = true

var btn = {
	"border": secondery_color,
	"fill": primary_color,
	"text": secondery_color,
	"margins": 8
}

var btn_hover = {
	"border": primary_color,
	"fill": secondery_color,
	"text": primary_color,
}

var rarity_default = {
	1: "117733",
	2: "332288",
	3: "EE7733"
}

var rarity = {
	1: "117733",
	2: "332288",
	3: "EE7733"
}

var default_keyboard = false
var background_volume
var sfx_volume

var actions_dict = {
	"sell": "SELL",
	"up": "UP",
	"down": "DOWN",
	"left": "LEFT",
	"right": "RIGHT",
	"interact": "INTERACT",
	"cancel": "CANCEL",#keyboard_mode
	"keyboard_mode": "KEYBOARD MODE",
	"rotate": "ROTATE"
}

func _ready():
	load_config()

func save_config(_primary_color, _secondery_color, _tertiary_color):
	var file = FileAccess.open("res://Save/Config/config_save.json", FileAccess.WRITE_READ)
	
	var save_dict = {
		"primary" : _primary_color,
		"secondery" : _secondery_color,
		"tertiary" : _tertiary_color,
		"fullscreen": fullscreen
	}
	
	var json_string = JSON.stringify(save_dict)
	file.store_line(json_string)

func load_config():
	print("LOADING CONFIG")
	if FileAccess.file_exists("user://default_options_save.json"):
		print("FILE EXISTS")
	else:
		print("DOESN'T EXIST")
	default_primary_color = Color.html("#ebe5ce")
	default_secondery_color = Color.html("#2e3037")
	default_hp_color = Color.html("#CC3311")
	
	var file = "user://options_save.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
		
	primary_color =  Color.html(json_as_dict["primary"])#Color.html("#ebe5ce")
	secondery_color =  Color.html(json_as_dict["secondary"])#Color.html("#2e3037")
	hp_color =  Color.html(json_as_dict["hp"])#Color.html("#CC3311")
	fullscreen = json_as_dict["fullscreen"]
	
	rarity[1] = json_as_dict["common_color"]
	rarity[2] = json_as_dict["rare_color"]
	rarity[3] = json_as_dict["legendary_color"]
	
	default_keyboard = json_as_dict["default_keyboard"]
	
	background_volume = json_as_dict["background_volume"]
	sfx_volume = json_as_dict["sfx_volume"]
	
	TextManager.lang = json_as_dict["lang"]
	
	for i in actions_dict:
		var input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(json_as_dict[i])
		input_event.physical_keycode = OS.find_keycode_from_string(json_as_dict[i])
		
		InputMap.action_erase_events(i)
		InputMap.action_add_event(i, input_event)

func load_default():
	var file = "res://Game V2/Saves/default_config_save.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	
	fullscreen = json_as_dict["fullscreen"]
	return json_as_dict

