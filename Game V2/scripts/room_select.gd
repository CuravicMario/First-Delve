extends Node2D

var can_leave = true

var current_room = 1
var num_of_rooms = 8
var floor = 1
var max_floor = 2

var percent_for_room = [55, 35, 10]

@onready var room_select_icons = [$RoomSelectIcon, $RoomSelectIcon2, $RoomSelectIcon3]
@onready var boss_icon = $"Boss Icon"
@onready var combat = $"../Combat"
@onready var shop = $"../Shop"
@onready var event = $"../Event"
@onready var pieces = $"../pieces"
@onready var lowest_elements = [$RoomSelectIcon, $RoomSelectIcon2, $RoomSelectIcon3, $"Boss Icon"]
@onready var tutorial = $"../Tutorial"

enum Room_Types  {
	COMBAT,
	SHOP,
	EVENT,
	BOSS
}

var floor_dict = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.in_tutorial:
		create_tutorial()
	else:
		create_floor()
	current_room = 0
	
	combat.deactivate()
	shop.deactivate()
	event.deactivate()
	
	if floor == 1 or Global.in_tutorial:
		current_room += 1
		combat.activate(1, false)#FIRST COMBAT ALWAYS THE SAME ID = 1
		#shop.activate()
	else:
		activate()
		current_room += 1

func create_floor():
	var room_level_generating = 1
	floor_dict = {}
	if floor == 1:
		floor_dict[room_level_generating] = {
			1 : {
				Room_Types.COMBAT : 1
			}
		}
		room_level_generating += 1
		
		for i in range(2, num_of_rooms):
			floor_dict[room_level_generating] = {}
			#print(i)
			
			for j in 3:
				var random_number = Global.random.randi_range(1, 100)
				if random_number < percent_for_room[2]: #checks if the room is a shop
					#print("SHOP")
					floor_dict[room_level_generating][j] = {
						Room_Types.SHOP : 1
					}
				elif  random_number < percent_for_room[1] + percent_for_room[2]: #checks if the room is an event
					#print("EVENT")
					var possible_event_ids = Global.get_posible_id_for_floor(Global.event_db, floor)
					var random_id = Global.random.randi_range(0, possible_event_ids.size() - 1)
					floor_dict[room_level_generating][j] = {
						Room_Types.EVENT : possible_event_ids[random_id]
					} #LATER GENERATE ID FOR EVENT & COMBAT
				else: #room is combat
					#print("COMBAT")
					var possible_combat_encounter_ids = Global.get_posible_combat_id_for_floor(Global.enemy_encounter_db, floor)
					var random_id = Global.random.randi_range(0, possible_combat_encounter_ids.size() - 1)
					floor_dict[room_level_generating][j] = {
						Room_Types.COMBAT : possible_combat_encounter_ids[random_id]
					}
			
			room_level_generating += 1
		
		floor_dict[room_level_generating] = {
			0 : {
				Room_Types.BOSS : 10
			}
		}
	else:
		for i in range(1, num_of_rooms):
			floor_dict[room_level_generating] = {}
			#print(i)
			
			for j in 3:
				var random_number = Global.random.randi_range(1, 100)
				if random_number < percent_for_room[2]: #checks if the room is a shop
					#print("SHOP")
					floor_dict[room_level_generating][j] = {
						Room_Types.SHOP : 1
					}
				elif  random_number < percent_for_room[1] + percent_for_room[2]: #checks if the room is an event
					#print("EVENT")
					var possible_event_ids = Global.get_posible_id_for_floor(Global.event_db, 1)
					var random_id = Global.random.randi_range(0, possible_event_ids.size() - 1)
					floor_dict[room_level_generating][j] = {
						Room_Types.EVENT : possible_event_ids[random_id]
					}
				else: #room is combat
					#print("COMBAT")
					var possible_combat_encounter_ids = Global.get_posible_combat_id_for_floor(Global.enemy_encounter_db, floor)
					var random_id = Global.random.randi_range(0, possible_combat_encounter_ids.size() - 1)
					floor_dict[room_level_generating][j] = {
						Room_Types.COMBAT : possible_combat_encounter_ids[random_id]
					}
			
			room_level_generating += 1
		
		floor_dict[room_level_generating] = {
			0 : {
				Room_Types.BOSS : 18
			}
		}

func create_tutorial():
	floor_dict[1] = {
			1 : {
				Room_Types.COMBAT : 1
			}
	}
	
	floor_dict[2] = {
			0 : {
				Room_Types.SHOP : 1
			},
			1 : {
				Room_Types.SHOP : 1
			},
			2 : {
				Room_Types.SHOP : 1
			}
	}
	
	floor_dict[3] = {
			0 : {
				Room_Types.EVENT : 1
			},
			1 : {
				Room_Types.EVENT : 1
			},
			2 : {
				Room_Types.EVENT : 1
			}
	}
	
	floor_dict[4] = {
		0 : {
			Room_Types.BOSS : 7
		}
	}

func move_room(room_type, id):
	
	if Global.keyboard_input:
		Global.current_focus.unfocus()
		Global.current_focus = pieces
		Global.current_focus.focus()
		if Global.in_sub_focus:
			pieces.active = false
			Global.in_sub_focus = false
			pieces.sub_focus.unfocus()
			pieces.sub_focus = null
	
	match room_type:
		Room_Types.COMBAT: 
			deactivate()
			combat.activate(id, false)
		Room_Types.SHOP: 
			deactivate()
			shop.activate()
		Room_Types.EVENT: 
			deactivate()
			event.activate(id)
		Room_Types.BOSS: 
			deactivate()
			combat.activate(id, true)
	
	
	
	current_room += 1

func move_floor():
	floor += 1
	current_room = 0
	
	create_floor()
	
	combat.deactivate()
	shop.deactivate()
	event.deactivate()
	
	if floor == 1 or Global.in_tutorial:
		current_room += 1
		combat.activate(1, false)#FIRST COMBAT ALWAYS THE SAME ID = 1
		#shop.activate()
	else:
		activate()
		current_room += 1

func is_last_floor():
	if floor == max_floor:
		return true
	else:
		return false

func activate():
	print("A")
	if Global.keyboard_input:
		Global.current_focus.unfocus()
		Global.current_focus = pieces
		Global.current_focus.focus()
		
		if Global.in_sub_focus:
			pieces.active = false
			Global.in_sub_focus = false
			pieces.sub_focus.unfocus()
			pieces.sub_focus = null
	
	for i in lowest_elements:
		i.DOWN_NEIGHBOUR = pieces
	
	if current_room+1 == floor_dict.size():
		for i in 3:
			room_select_icons[i].visible = false
		boss_icon.visible = true
		print(floor_dict[current_room+1])
		var room = floor_dict[current_room+1][0].keys()[0]
		boss_icon.id = floor_dict[current_room+1][0].values()[0]
		boss_icon.room_type = room
		pieces.UP_NEIGHBOUR = lowest_elements[3]
	else:
		pieces.UP_NEIGHBOUR = lowest_elements[0]
		boss_icon.visible = false
		for i in 3:
			var room = floor_dict[current_room+1][i].keys()[0]
			room_select_icons[i].visible = true
					
			match room:
				Room_Types.COMBAT: 
					room_select_icons[i].icon.region_rect = Rect2(0, 0, 48, 80)
					room_select_icons[i].id = floor_dict[current_room+1][i].values()[0]
					room_select_icons[i].room_type = room
				Room_Types.SHOP: 
					room_select_icons[i].icon.region_rect = Rect2(96, 0, 48, 80)
					room_select_icons[i].id = floor_dict[current_room+1][i].values()[0]
					room_select_icons[i].room_type = room
				Room_Types.EVENT: 
					room_select_icons[i].icon.region_rect = Rect2(48, 0, 48, 80)
					room_select_icons[i].id = floor_dict[current_room+1][i].values()[0]
					room_select_icons[i].room_type = room
				Room_Types.BOSS: 
					room_select_icons[i].icon.region_rect = Rect2(0, 0, 48, 80)
					room_select_icons[i].id = floor_dict[current_room+1][i].values()[0]
					room_select_icons[i].room_type = room

	
	self.visible = true

func deactivate():
	self.visible = false
