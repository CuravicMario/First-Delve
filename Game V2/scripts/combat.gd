extends Node2D

@export var possible_enemy_pos_row1 = [Vector2(0,0)] #0 - top_pos, 1-bot_pos, 2-mid_pos
@export var possible_enemy_pos_row2 = [Vector2(0,0)]
@export var player:Node

@onready var lowest_elements = [$CombatStartBtn, $"Room Complete", $NextFloor]
@onready var enemy = load("res://Game V2/Scenes/enemy.tscn")
@onready var enemy_holder = $Enemies
@onready var combat_start_btn = $CombatStartBtn
@onready var room_complete_btn = $"Room Complete"
@onready var next_floor_btn = $NextFloor
@onready var player_sprite = $"../PlayerSprite"
@onready var room_select = $"../RoomSelect"
@onready var pieces = $"../pieces"
@onready var border = $Border
@onready var reward = $Reward
@onready var defeat = $Defeat
@onready var tutorial = $"../Tutorial"
@onready var canvas = $"../../../../CanvasLayer"

var encounter_id
var boss_fight = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	border.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	pass # Replace with function body.

func activate(id, is_boss_fight):
	set_up_encounter(id)
	boss_fight = is_boss_fight
	player_sprite.visible = true
	self.visible = true
	pieces.UP_NEIGHBOUR = lowest_elements[0]
	for i in lowest_elements:
		i.DOWN_NEIGHBOUR = pieces
	
	if Global.in_tutorial and boss_fight:
		tutorial.open_tutorial()

func deactivate():
	combat_start_btn.dont_show()
	room_complete_btn.dont_show()
	next_floor_btn.dont_show()
	reward.dont_show()
	defeat.dont_show()
	player_sprite.visible = false
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_up_encounter(id):
	encounter_id = id
	room_complete_btn.dont_show()
	combat_start_btn.do_show()
	var encounter = Global.get_by_id(Global.enemy_encounter_db, id)
	
	var enemy_id_list = encounter["enemyids"].split("/")
	print(enemy_id_list)
	for i in enemy_id_list:
		i = int(i)
	
	var counter = 0
	var row_counter = 0
	
	for enemy_id in enemy_id_list: 
		if int(enemy_id) == 0:
			break
		var temp_enemy = load(Global.get_by_id(Global.enemy_db, int(enemy_id))["path"]).instantiate()
		
		#ADDING NEIGHBOURS FOR KEYBOARD NAVIGATION
		temp_enemy.DOWN_NEIGHBOUR = combat_start_btn
		##########################################
		
		enemy_holder.add_child(temp_enemy)
		temp_enemy.generate_me(int(enemy_id))
		temp_enemy.assaign_player(player)
		temp_enemy.canvas = canvas
		
		#determine the position
		if counter < encounter["numrow1"]:
			if encounter["numrow1"] == 1:
				temp_enemy.position = possible_enemy_pos_row1[2]
			elif row_counter == 0:
				temp_enemy.position = possible_enemy_pos_row1[row_counter]
				row_counter += 1
				pass#place top(0)
			else:
				temp_enemy.position = possible_enemy_pos_row1[row_counter]
				row_counter = 0
				pass#place bot(1)
		else:
			if encounter["numrow2"] == 1:
				temp_enemy.position = possible_enemy_pos_row2[2]
			elif row_counter == 0:
				temp_enemy.position = possible_enemy_pos_row2[row_counter]
				row_counter += 1
				pass#place top(0)
			else:
				temp_enemy.position = possible_enemy_pos_row2[row_counter]
				row_counter = 0
				pass#place bot(1)
		
		counter += 1
	
	player.list_of_enemies = enemy_holder.get_children()
	
	print(enemy_id_list)
	
	player.RIGHT_NEIGHBOUR = player.list_of_enemies[0]
	player.DOWN_NEIGHBOUR = combat_start_btn
	
	set_up_enemy_neighbours()


func start_combat():
	if Global.keyboard_input:
		Global.current_focus.unfocus()
		Global.current_focus = pieces
		Global.current_focus.focus()
		Global.combat_end = false
	player.start_combat()
	
	for i in enemy_holder.get_children():
		i.start_combat()
	pass

func pause_combat():
	player.pause_timer()
	
	for i in enemy_holder.get_children():
		i.pause_timer()

func end_combat(win):
	Global.combat_end = false
	player.pause_timer()
	player.end_combat()
	
	for i in enemy_holder.get_children():
		i.pause_timer()
	
	if win:
		combat_start_btn.dont_show()
		if boss_fight:
			if room_select.is_last_floor() or Global.in_tutorial:
				pieces.UP_NEIGHBOUR = defeat.return_btn
				show_defeat()
				defeat.change_text(131,132)
			else:
				show_reward(choose_combat_reward(Global.get_by_id(Global.enemy_encounter_db, encounter_id)["rewarditemchance"]))
				reward.take_btn.DOWN_NEIGHBOUR = next_floor_btn
				next_floor_btn.do_show()
				pieces.UP_NEIGHBOUR = lowest_elements[2]
		else:
			show_reward(choose_combat_reward(Global.get_by_id(Global.enemy_encounter_db, encounter_id)["rewarditemchance"]))
			reward.take_btn.DOWN_NEIGHBOUR = room_complete_btn
			room_complete_btn.do_show()
			pieces.UP_NEIGHBOUR = lowest_elements[1]
	else:
		combat_start_btn.dont_show()
		pieces.UP_NEIGHBOUR = defeat.return_btn
		show_defeat()

func choose_combat_reward(reward_chance):
	var  equipment = []
	var chances = reward_chance.split("/")
	
	var rand_num = Global.random.randi_range(1,100)
	
	if rand_num < int(chances[0]):
		equipment = Global.get_equipment_of_rarity(1)
	elif rand_num < int(chances[0]) + int(chances[1]):
		equipment = Global.get_equipment_of_rarity(2)
	else:
		equipment = Global.get_equipment_of_rarity(3)
	
	var rand_id = Global.random.randi_range(0, equipment.size()-1)
	
	print("equipmentREWARD")
	print(equipment)
	print(equipment[rand_id])
	
	return equipment[rand_id]
	

func choose_an_item(chance):	
	var possible_rewards_common_ids = Global.get_equipment_of_rarity(1)
	var possible_rewards_rare_ids = Global.get_equipment_of_rarity(2)
	var possible_rewards_legendary_ids = Global.get_equipment_of_rarity(3)
	
	#Goose wich rarity based on rhe floor
	var choose_rarity = Global.random.randi_range(0,100)
	
	var chosen_reward_id
	
	if choose_rarity < chance[0]:
		chosen_reward_id = Global.random.randi_range(0, possible_rewards_common_ids.size()-1)
		return possible_rewards_common_ids[chosen_reward_id]
	elif choose_rarity < chance[0] + chance[1]:
		chosen_reward_id = Global.random.randi_range(0, possible_rewards_rare_ids.size()-1)
		return possible_rewards_common_ids[chosen_reward_id]
	else:
		chosen_reward_id = Global.random.randi_range(0, possible_rewards_legendary_ids.size()-1)
		return possible_rewards_rare_ids[chosen_reward_id]

func show_reward(reward_id):
	player.visible = false
	reward.do_show(reward_id)
	
	room_complete_btn.UP_NEIGHBOUR = reward.take_btn
	
	if Global.in_tutorial:
		tutorial.open_tutorial()

func show_defeat():
	for i in enemy_holder.get_children():
		i.visible = false
	
	player.visible = false
	defeat.do_show()

func remove_enemy(defeated_enemy):
	for i in enemy_holder.get_children():
		if i == defeated_enemy:
			i.queue_free()

func number_to_digits(n):
	var digit_array = []
	for digit in str(n):
		if digit.is_valid_int():
			digit_array.push_back(digit.to_int())
	return digit_array


func set_up_enemy_neighbours():
	var count = 0
	var enemies = enemy_holder.get_children()
	
	var left_position_occupied = [false,false,false]
	var left_neighbours = [null,null,null]
	
	for enemy in enemies:
		print(enemy)
		print(enemy.position)
		print(possible_enemy_pos_row1[0])
		match enemy.position:
			Vector2(24,-40):
				enemy.DOWN_NEIGHBOUR = enemies[count+1]
				enemy.LEFT_NEIGHBOUR = player
				player.RIGHT_NEIGHBOUR = enemy
				left_position_occupied[0] = true
				left_neighbours[0] = enemy
			Vector2(24,48):
				enemy.UP_NEIGHBOUR = enemies[count-1]
				enemy.LEFT_NEIGHBOUR = player
				left_position_occupied[1] = true
				left_neighbours[1] = enemy
			Vector2(24,0):
				enemy.LEFT_NEIGHBOUR = player
				left_position_occupied[2] = true
				left_neighbours[2] = enemy
				player.RIGHT_NEIGHBOUR = enemy
			Vector2(104,-40):
				enemy.DOWN_NEIGHBOUR = enemies[count+1]
				if left_position_occupied[0]:
					enemy.LEFT_NEIGHBOUR = left_neighbours[0]
					left_neighbours[0].RIGHT_NEIGHBOUR = enemy
				elif left_position_occupied[2]:
					enemy.LEFT_NEIGHBOUR = left_neighbours[2]
					left_neighbours[2].RIGHT_NEIGHBOUR = enemy
				else:
					enemy.LEFT_NEIGHBOUR = player
					player.RIGHT_NEIGHBOUR = enemy
			Vector2(104,48):
				enemy.UP_NEIGHBOUR = enemies[count-1]
				if left_position_occupied[1]:
					enemy.LEFT_NEIGHBOUR = left_neighbours[1]
					left_neighbours[1].RIGHT_NEIGHBOUR = enemy
				elif left_position_occupied[2]:
					enemy.LEFT_NEIGHBOUR = left_neighbours[2]
				else:
					enemy.LEFT_NEIGHBOUR = player
			Vector2(104,0):
				if left_position_occupied[0]:
					enemy.LEFT_NEIGHBOUR = left_neighbours[0]
					left_neighbours[0].RIGHT_NEIGHBOUR = enemy
					left_neighbours[1].RIGHT_NEIGHBOUR = enemy
				elif left_position_occupied[2]:
					enemy.LEFT_NEIGHBOUR = left_neighbours[2]
					left_neighbours[2].RIGHT_NEIGHBOUR = enemy
				else:
					enemy.LEFT_NEIGHBOUR = player
					player.RIGHT_NEIGHBOUR = enemy
			_:
				pass
		count += 1
