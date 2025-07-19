extends Node2D

var value = 0
var label

@export var languages:Array[String]
@export var label_group:String
@export var language_names:Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_tree().get_first_node_in_group(label_group)
	label.resize_self(Vector2(124,16))
	label.position_self(self.position)
	label.modulate = Style.primary_color
	
	value = languages.find(TextManager.lang)
	
	change_language_name()

func change_language_name():
	label.text = TextManager.get_text_by_id(language_names[value])

func rise():
	value +=1
	
	if value >= languages.size():
		value = 0
	
	change_language_name()

func lower():
	value -=1
	
	if value < 0:
		value = languages.size() - 1
	
	change_language_name()

func do_show():
	visible = true
	label.visible = true

func dont_show():
	visible = false
	label.visible = false
