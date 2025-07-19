extends CharacterBody2D

@export var label_group:String
@export var btn_real_pos:Vector2
@export var text_id:int
@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node
@export var pieces: Node

var label
var in_focus = false
var taken

@onready var parrent_node = $".."
@onready var hover_border = $HoverBorder
@onready var border = $Border

func _ready():
	label = get_tree().get_first_node_in_group(label_group)
	label.position_self(btn_real_pos)
	label.modulate = Style.primary_color
	change_text(text_id)
	
	border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	border.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)


func _physics_process(delta):
	if in_focus:
		if (Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact")) and not taken:
			var possible_position = pieces.board.place_on_board(parrent_node.reward)
			if possible_position == null:
				AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ERROR)
			else:
				parrent_node.reward.position = possible_position
				parrent_node.reward.ref = pieces.board
				parrent_node.reward.start_insert()
				taken = true
			

func change_text(id):
	label.text = TextManager.get_text_by_id(id)

func dont_show():
	visible = false 
	label.visible = false

func do_show():
	visible = true 
	label.visible = true

func focus():
	hover_border.visible = true
	in_focus = true

func unfocus():
	hover_border.visible = false
	in_focus = false

func _on_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input and !Global.tutorial:
		
		focus()

func _on_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input and !Global.tutorial:
		
		unfocus()
