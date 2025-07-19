extends Sprite2D

var in_focus = false

@onready var shop_slot = $".."
@onready var hover_border = $HoverBorder
@onready var price_pos = $Marker2D

@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_focus:
		if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact"):
			var possible_position = shop_slot.pieces.board.place_on_board(shop_slot.item)
			if shop_slot.player.has_enough_gold(shop_slot.item.rarity*2) and not possible_position == null:
				shop_slot.player.spend_gold(shop_slot.item.rarity*2)
				shop_slot.unlock()
			else:
				AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ERROR)


func focus():
	in_focus = true
	hover_border.visible = true

func unfocus():
	in_focus = false
	hover_border.visible = false


func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input and not Global.combat_end:
		
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input and not Global.combat_end:
		
		unfocus()
