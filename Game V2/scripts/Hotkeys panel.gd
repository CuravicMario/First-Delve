extends OptionsPanel

var start_position = Vector2(312,40)
var labels = []

var is_remaping = false
var action_to_remap
var button_to_remap

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

@onready var hotkey_label = load("res://Game V2/Scenes/UI_hotkey_label.tscn")
@onready var hotkey_button = load("res://Game V2/Scenes/option_hotkey.tscn")
@onready var UI_canvas = $"../../../../../CanvasLayer"
@onready var graphics_tab = $"../../Tabs/Graphics"
@onready var save_btn = $"../../SaveOptions2"
@onready var viewport = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var count = 0
	for i in actions_dict:
		add_hotkey_button(i, count)
		count += 1
	
	add_neighbors()

func add_hotkey_button(action, offset):
	var temp_button = hotkey_button.instantiate()
	add_child(temp_button)
	temp_button.position = start_position + Vector2(0,24*offset)
	temp_button.action = action
	
	var temp_label = hotkey_label.instantiate()
	UI_canvas.add_child(temp_label)	
	temp_label.resize_self(Vector2(200,16))
	temp_label.position_self(temp_button.position)
	temp_label.modulate = Style.primary_color
	temp_label.action_name.text = actions_dict[action]
	temp_label.button.text = str(InputMap.action_get_events(action)[0].as_text_physical_keycode())
	labels.append(temp_label)
	
	temp_button.label = temp_label

func add_neighbors():
	var hotkey_buttons = get_children()
	first_element = hotkey_buttons[0]
	
	var count = 0
	for i in hotkey_buttons:
		i.LEFT_NEIGHBOUR = graphics_tab
		if not (count == 0):
			i.UP_NEIGHBOUR = hotkey_buttons[count - 1]
		
		if not (count == hotkey_buttons.size()):
			i.DOWN_NEIGHBOUR = hotkey_buttons[count - 1]
		else:
			i.DOWN_NEIGHBOUR = save_btn
		
		count += 1

func do_show():
	for i in labels:
		i.visible = true
	self.visible = true
	TAB.underline.visible = true
	for i in children:
		i.do_show()

func dont_show():
	for i in labels:
		i.visible = false
	self.visible = false
	TAB.underline.visible = false
	for i in children:
		i.dont_show()

func _unhandled_input(event):
	if is_remaping:
		if (event is InputEventKey):
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			button_to_remap.update_text()
			is_remaping = false
			action_to_remap = null
			button_to_remap = null
			get_viewport().set_input_as_handled() 
