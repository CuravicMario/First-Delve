extends Node2D

@export var item_holder:Node
@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node
@export var player:Node
@export var pieces:Node

var unlocked = false
var item

@onready var room_select = $"../../RoomSelect"
@onready var icon_frame = $IconFrame
@onready var price_sign = $PriceSign
@onready var price_hover = $PriceSign/HoverBorder

# Called when the node enters the scene tree for the first time.
func _ready():
	icon_frame.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	icon_frame.material.set_shader_parameter("replace_color_1", Style.primary_color)
	icon_frame.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	icon_frame.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	price_sign.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	price_sign.material.set_shader_parameter("replace_color_1", Style.primary_color)
	price_sign.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	price_sign.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	price_hover.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	price_hover.material.set_shader_parameter("replace_color_1", Style.primary_color)
	price_hover.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	price_hover.material.set_shader_parameter("replace_color_2", Style.secondery_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func unlock():
	var possible_position = pieces.board.place_on_board(item)
	if possible_position == null:
		AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ERROR)
	else:
		room_select.can_leave = false
		item.position = possible_position
		item.ref = pieces.board
		item.start_insert()

func focus():
	item.focus()

func unfocus():
	item.unfocus()

func _on_area_2d_mouse_entered():
	if not unlocked:
		Global.item_not_unlocked = true
	else:
		Global.item_not_unlocked = false


func _on_area_2d_mouse_exited():
	Global.item_not_unlocked = false
