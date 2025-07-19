extends Sprite2D

@export var pos:Node
@export var combat_controll_node:Node
@export var gold_popup_pos:Node
@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node

var base_player_stats = {
		"name": "Player",
		"hp": 400,
		"atk": 35,
		"atkspeed": 0.55,
		"crit": 0,
		"critamp": 2,
		"armor": 40,
		"lifesteal": 0,
		"dodge": 0,
		"mana": 0,
		"manaper": 0,
		"gold": 3
}

var player_stats = {
		"name": "Player",
		"hp": 400,
		"atk": 35,
		"atkspeed": 0.55,
		"crit": 0,
		"critamp": 0,
		"armor": 40,
		"lifesteal": 0,
		"dodge": 0,
		"mana": 0,
		"manaper": 0,
		"gold": 3
}
var current_hp
var list_of_enemies

var killed_enemy = false
var in_focus = false
var can_move_items = true

@onready var atk_timer = $"Atk Progress"
@onready var atk_timer_visualisation = $"Timer Border/TextureProgressBar"
@onready var hp_bar_visualisation = $"Health bar/TextureProgressBar"
@onready var hp_bar = $"Health bar"
@onready var atk_timer_bar = $"Timer Border"
@onready var info = $"../Info"
@onready var dmg_popup = $DamagePopupPos
@onready var canvas = $"../../../../CanvasLayer"
@onready var hover_border = $Hover_border
@onready var equipment = $"../pieces"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position = pos.global_position
	
	atk_timer.wait_time = 1.0 / player_stats["atkspeed"]
	current_hp = player_stats["hp"]
	
	hp_bar_visualisation.self_modulate = Style.hp_color
	hp_bar_visualisation.max_value = player_stats["hp"]
	hp_bar_visualisation.value = current_hp
	info.return_to_default_info()
	
	self.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	self.material.set_shader_parameter("replace_color_1", Style.primary_color)
	self.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	self.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	hp_bar.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hp_bar.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hp_bar.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hp_bar.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	atk_timer_bar.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	atk_timer_bar.material.set_shader_parameter("replace_color_1", Style.primary_color)
	atk_timer_bar.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	atk_timer_bar.material.set_shader_parameter("replace_color_2", Style.secondery_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not atk_timer.paused:
		atk_timer_visualisation.value = ((atk_timer.wait_time - atk_timer.time_left) / atk_timer.wait_time) * 100


func start_combat():
	can_move_items = false
	atk_timer.paused = false
	atk_timer.start()

func end_combat():
	can_move_items = true
	
	for i in equipment.get_children():
		if i.has_method("on_end_of_combat"):
			i.on_end_of_combat()
	

func pause_timer():
	atk_timer.paused = true

func take_dmg(pre_mitigation):
	var post_mitigation = roundf(pre_mitigation/(1 + (player_stats["armor"]/100.0)))
	
	current_hp -= post_mitigation
	if current_hp < 0:
		current_hp = 0
		combat_controll_node.end_combat(false)
	
	hp_bar_visualisation.value = current_hp
	if in_focus or info.is_default_focus:
		info.update_info(true,player_stats,current_hp)
	
	if Global.random.randi_range(1, 100) < player_stats["dodge"]:
		post_mitigation = 0
		NumberPopup.display_number("DODGE", dmg_popup.global_position, true, canvas)
	else:
		NumberPopup.display_number("-" + str(post_mitigation), dmg_popup.global_position, false, canvas)
	return post_mitigation

func take_true_dmg(ammount):
	current_hp -= ammount
	NumberPopup.display_number("-" + str(ammount), dmg_popup.global_position, false, canvas)
	if in_focus or info.is_default_focus:
		info.update_info(true,player_stats,current_hp)

func deal_dmg():
	var target = list_of_enemies[0]
	var dmg = player_stats["atk"]
	
	var rand_num = Global.random.randi_range(1, 100)
	
	if (player_stats["crit"] > rand_num):
		dmg = 2 * dmg
	
	var dmg_delt = target.take_dmg(dmg)
	
	var lifesteal_ammount = roundf(dmg_delt * (player_stats["lifesteal"]/100.0))
	
	if lifesteal_ammount > 0:
		heal(lifesteal_ammount, false)
	if killed_enemy:
		change_base_stats("gold", 1, false)
		combat_controll_node.remove_enemy(target)
		killed_enemy = false
		
		list_of_enemies.erase(target)
		
		if list_of_enemies.is_empty():
			combat_controll_node.end_combat(true)
		
		pass

func heal(hp, percent):
	var healing = hp
	if percent:
		healing = player_stats["hp"] * hp
	
	current_hp += healing
	
	if current_hp > player_stats["hp"]:
		current_hp = player_stats["hp"]
	
	NumberPopup.display_number("+" + str(healing), dmg_popup.global_position, false, canvas)
	hp_bar_visualisation.value = current_hp
	if in_focus or info.is_default_focus:
		info.update_info(true,player_stats,current_hp)

func _on_atk_progress_timeout():
	AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ATTACK_SWORD)
	deal_dmg()
	
	for i in equipment.get_children():
		if i.has_method("on_attack"):
			i.on_attack()
	
	if not Global.combat_end:
		atk_timer.start()

func change_base_stats(stats_changed, change_ammount, percent):
	if stats_changed == "current_hp":
		heal(change_ammount, percent)
	elif stats_changed == "hp":
		var percent_of_hp = float(current_hp/player_stats["hp"])
		player_stats[stats_changed] += change_ammount
		hp_bar_visualisation.max_value = player_stats["hp"]
		current_hp = int(player_stats["hp"]*percent_of_hp)
		hp_bar_visualisation.value = current_hp
	elif stats_changed == "atkspeed":
		var atk_speed_gain = base_player_stats["atkspeed"] * change_ammount
		player_stats[stats_changed] =  round_to_dec(atk_speed_gain + player_stats[stats_changed], 2)
	else:
		player_stats[stats_changed] += change_ammount
	if in_focus or info.is_default_focus:
		info.update_info(true,player_stats,current_hp)
	
	if stats_changed == "gold":
		trigger_on_gold_changed()
		AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.GOLD)
		NumberPopup.display_number("+" + str(change_ammount), gold_popup_pos.global_position, true, canvas)

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func remove_stat(stats_changed, change_ammount):
	if stats_changed == "current_hp":
		take_true_dmg(change_ammount)
	elif stats_changed == "hp":
		var percent_of_hp = float(current_hp/player_stats["hp"])
		player_stats[stats_changed] -= change_ammount
		hp_bar_visualisation.max_value = player_stats["hp"]
		current_hp = int(player_stats["hp"]*percent_of_hp)
		hp_bar_visualisation.value = current_hp
	elif stats_changed == "atkspeed":
		var atk_speed_gain = base_player_stats["atkspeed"] * change_ammount
		player_stats[stats_changed] =  round_to_dec(player_stats[stats_changed] - atk_speed_gain, 2)
	else:
		player_stats[stats_changed] -= change_ammount
	if in_focus or info.is_default_focus:
		info.update_info(true,player_stats,current_hp)
	if stats_changed == "gold":
		trigger_on_gold_changed()
		AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.GOLD)
		NumberPopup.display_number("-" + str(change_ammount), gold_popup_pos.global_position, true, canvas)

func has_enough_gold(ammount):
	if player_stats["gold"] >= ammount:
		return true
	else:
		return false

func trigger_on_gold_changed():
	
	for i in equipment.get_children():
		if i.has_method("on_gold_changed"):
			i.on_gold_changed()

func check_if_have_enough(stat, ammount):
	if stat == "current_hp":
		if current_hp >= ammount:
			return true
		else:
			return false
	else:
		if player_stats[stat] >= ammount:
			return true
		else:
			return false

func spend_gold(ammount):
	change_base_stats("gold",ammount*(-1), false)

func focus():
	info.update_info(true,player_stats,current_hp)
	in_focus = true
	hover_border.visible = true

func unfocus():
	info.return_to_default_info()
	in_focus = false
	hover_border.visible = false

func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input and !Global.tutorial:
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input and !Global.tutorial:
		unfocus()











