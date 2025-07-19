extends Sprite2D
class_name BaseEnemy

var enemy_id
var enemy_info
var player
var current_hp
var in_focus = false
var canvas

@onready var atk_timer = $"Atk Progress"
@onready var atk_timer_visualisation = $"Timer Border/TextureProgressBar"
@onready var hp_bar_visualisation =$"Health bar/TextureProgressBar"
@onready var hp_bar = $"Health bar"
@onready var atk_timer_bar = $"Timer Border"
@onready var info =$"../../../Info"
@onready var hover_border = $Hover_border
@onready var dmg_popup = $DamagePopupPos

@export var UP_NEIGHBOUR:Node
@export var RIGHT_NEIGHBOUR:Node
@export var DOWN_NEIGHBOUR:Node
@export var LEFT_NEIGHBOUR:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_me(1)
	
	atk_timer.wait_time = 1.0 / float(enemy_info["atkspeed"])
	current_hp = enemy_info["hp"]
	
	hp_bar_visualisation.self_modulate = Style.hp_color
	hp_bar_visualisation.max_value = enemy_info["hp"]
	hp_bar_visualisation.value = current_hp
	#atk_timer.start()
	
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
	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	pass

func start_combat():
	atk_timer.paused = false
	atk_timer.start()

func pause_timer():
	atk_timer.paused = true

func _process(delta):
	if not atk_timer.paused:
		atk_timer_visualisation.value = ((atk_timer.wait_time - atk_timer.time_left) / atk_timer.wait_time) * 100
	
	
	pass

func generate_me(id):
	enemy_id = id
	
	enemy_info = DBReader.get_row_by_id(DBReader.enemies, enemy_id)
	
	hp_bar_visualisation.max_value = enemy_info["hp"]
	current_hp = enemy_info["hp"]
	hp_bar_visualisation.value = current_hp
	#texture = load(enemy_info["spritelocation"])

func assaign_player(object):
	player = object

func take_dmg(pre_mitigation):
	var post_mitigation = roundf(pre_mitigation/(1 + (enemy_info["armor"]/100.0)))
		
	
	if current_hp - post_mitigation <= 0:
		post_mitigation = current_hp
		current_hp = 0
		
		player.killed_enemy = true
	else:
		current_hp -= post_mitigation
	
	hp_bar_visualisation.value = current_hp
	if in_focus:
		info.update_info(false,enemy_info,current_hp)
	
	NumberPopup.display_number("-" + str(post_mitigation), dmg_popup.global_position, false, canvas)
	return post_mitigation

func heal(hp):
	current_hp += hp
	
	if current_hp > enemy_info["hp"]:
		current_hp = enemy_info["hp"]
	
	NumberPopup.display_number("+" + str(hp), dmg_popup.global_position, false, canvas)
	hp_bar_visualisation.value = current_hp
	if in_focus:
		info.update_info(false,enemy_info,current_hp)


func _on_atk_progress_timeout():
	player.take_dmg(enemy_info["atk"])
	atk_timer.start()

func focus():
	info.update_info(false,enemy_info,current_hp)
	info.is_default_focus = false
	in_focus = true
	hover_border.visible = true

func unfocus():
	info.return_to_default_info()
	in_focus = false
	hover_border.visible = false

func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.keyboard_input:
		
		focus()


func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.keyboard_input:
		
		unfocus()
