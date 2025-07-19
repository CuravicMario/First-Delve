extends Sprite2D

var in_focus = false

var choice_id

@onready var event = $"../.."
@onready var player = $"../..".player
@onready var room_select = $"../..".room_select
@onready var hover_border = $HoverBorder

@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	self.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	self.material.set_shader_parameter("replace_color_1", Style.primary_color)
	self.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	self.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_focus:
		if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact"):
			var choice = Global.get_by_id(Global.choices_db, choice_id)
			made_a_choice(choice["change"],choice["stat"],choice["changeammount"],choice["reward"],choice["rewardtype"],choice["idreward"],choice["price"],choice["pstat"],choice["pchange"])


func made_a_choice(change_stats, stat_changed, stat_change_by, choose_a_reward, reward_type, reward_id, price, pstat, pchange):
	if price == "t":
		if player.check_if_have_enough(pstat, pchange):
			player.remove_stat(pstat, pchange)
		else:
			AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ERROR)
			return 
	
	if change_stats == "t":
		player.change_base_stats(stat_changed, stat_change_by, false)
		if room_select.can_leave:
			event.deactivate()
			room_select.activate()
	
	if choose_a_reward == "t":
		event.show_reward(choose_reward(reward_id, reward_type))#add id of reward later
	
	if choose_a_reward == "f" and change_stats == "f":
		if room_select.can_leave:
			event.deactivate()
			room_select.activate()
	

func choose_reward(reward_chance, reward_type):
	var  equipment = []
	var chances = reward_chance.split("/")
	
	var rand_num = Global.random.randi_range(0,99)
	
	if rand_num < int(chances[0]):
		equipment = Global.get_equipment_of_type_and_rarity(reward_type, 1)
	elif rand_num < int(chances[0]) + int(chances[1]):
		equipment = Global.get_equipment_of_type_and_rarity(reward_type, 2)
	else:
		equipment = Global.get_equipment_of_type_and_rarity(reward_type, 3)
	
	var rand_id = Global.random.randi_range(0, equipment.size()-1)
	
	
	return equipment[rand_id]


func focus():
	in_focus = true
	hover_border.visible = true

func unfocus():
	in_focus = false
	hover_border.visible = false


func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input and not Global.tutorial:
		
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input and not Global.tutorial:
		
		unfocus()
