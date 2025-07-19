extends Node2D

var is_dragging = false
var pieces_db
var equipment_db
var rarity_db
var stats_db
var enemy_encounter_db
var event_db
var choices_db
var enemy_db
var temp_room_db = ["res://Scenes/Shop.tscn","res://Scenes/Combat.tscn", "res://Scenes/Event.tscn"]
var save_file

var keyboard_input = false
var current_focus
var focus_points
var sub_focus = false
var buying = false
var room_locked = false
var in_pop_up = false

var in_sub_focus = false
var random = RandomNumberGenerator.new()

var piece_costs = {
	1: 3,
	2: 4,
	3: 5
}

var combat_end = false
var item_not_unlocked = false
var tutorial = false
var in_tutorial = false

func _ready():
	random.randomize()
	
	var file = "res://Game V2/Databases/combat_encounters.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	enemy_encounter_db = JSON.parse_string(json_as_text)
	
	
	file = "res://Game V2/Databases/rarity.json"
	json_as_text = FileAccess.get_file_as_string(file)
	rarity_db = JSON.parse_string(json_as_text)
	
	
	file = "res://Game V2/Databases/events.json"
	json_as_text = FileAccess.get_file_as_string(file)
	event_db = JSON.parse_string(json_as_text)
	
	file = "res://Game V2/Databases/choices.json"
	json_as_text = FileAccess.get_file_as_string(file)
	choices_db = JSON.parse_string(json_as_text)
	
	
	file = "res://Game V2/Databases/equipment.json"
	json_as_text = FileAccess.get_file_as_string(file)
	equipment_db = JSON.parse_string(json_as_text)
	
	
	file = "res://Game V2/Databases/enemies.json"
	json_as_text = FileAccess.get_file_as_string(file)
	enemy_db = JSON.parse_string(json_as_text)

func _process(delta):
	if Input.is_action_just_pressed("keyboard_mode"):
		if keyboard_input:
			keyboard_input = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			current_focus.unfocus()
			current_focus = null
			in_sub_focus = false
		else:
			keyboard_input = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			current_focus = focus_points
			current_focus.focus()
	
	if keyboard_input and !in_sub_focus:
		if Input.is_action_just_pressed("up") and !current_focus.UP_NEIGHBOUR == null:
			current_focus.unfocus()
			current_focus = current_focus.UP_NEIGHBOUR
			current_focus.focus()
		if Input.is_action_just_pressed("down") and !current_focus.DOWN_NEIGHBOUR == null:
			current_focus.unfocus()
			current_focus = current_focus.DOWN_NEIGHBOUR
			current_focus.focus()
		if Input.is_action_just_pressed("left") and !current_focus.LEFT_NEIGHBOUR == null:
			current_focus.unfocus()
			current_focus = current_focus.LEFT_NEIGHBOUR
			current_focus.focus()
		if Input.is_action_just_pressed("right") and !current_focus.RIGHT_NEIGHBOUR == null:
			current_focus.unfocus()
			current_focus = current_focus.RIGHT_NEIGHBOUR
			current_focus.focus()
	


func get_equipment_of_rarity(rarity_id):
	var eligable_equipment = []
	
	for i in equipment_db:
		if i["rarity"] == rarity_id:
			eligable_equipment.append(i["id"])
	
	return eligable_equipment

func get_equipment_of_type_and_rarity(type, rarity):
	var eligable_equipment = []
	
	for i in equipment_db:
		if i["rarity"] == rarity and i["type"] == type:
			eligable_equipment.append(i["id"])
	
	return eligable_equipment

func get_posible_id_for_floor(db, floor):
	var eligible_ids = []
	
	for i in db:
		if i["flooraplicable"] == floor:
			eligible_ids.append(i["id"])
	
	return eligible_ids

func get_posible_combat_id_for_floor(db, floor):
	var eligible_ids = []
	
	for i in db:
		if i["flooraplicable"] == floor and i["boss"] == 0:
			eligible_ids.append(i["id"])
	
	return eligible_ids

func get_by_id(db, id):
	for i in db.size():
		if db[i]["id"] == id:
			return db[i]

func get_db_row(db, row_name, query):
	print(row_name)
	print(query)
	for i in db.size():
		print(db[i][row_name])
		if db[i][row_name] == query:
			return db[i]

func player_board_to_dict(board, pieces):
	var save_dict = {
		"board" : [],
		"pieces": {}
		}
	
	
	for x in board.grid.width:
		for y in board.grid.height:
			save_dict["board"].append(save_cell(board.grid.get_cell(x,y)))
	
	for piece in pieces:
		save_dict["pieces"][piece] = save_piece(piece)
		
	return save_dict

func save_player(board, pieces, file):
	var save_game = file
	
	var save_dict = {
		"board" : [],
		"pieces": {}
		}
	
	
	for x in board.grid.width:
		for y in board.grid.height:
			save_dict["board"].append(save_cell(board.grid.get_cell(x,y)))
	
	for piece in pieces:
		save_dict["pieces"][piece] = save_piece(piece)
		
	var json_string = JSON.stringify(save_dict)
	save_game.store_line(json_string)
	return save_dict

func save_cell(cell):
	var cell_dict = {
		"cord" : cell.cord,
		"occupied" : cell.occupied,
		"object": cell.object,
		"object_name": cell.object_name
	}
	
	return cell_dict

func save_piece(piece):
	var piece_dict = {
		"position": piece.offset_pos,
		"rotation": piece.old_rotation_deg,
		"id": piece.id
	}
	
	
	return piece_dict

func load_board(board_area, _file):
	var file = _file
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	var board = json_as_dict["board"]
	######LOAD CELLS OF THE BOARD
	var index = 0
	for x in board_area.grid.width:
		for y in board_area.grid.height:
			var cell = board_area.grid.get_cell(x,y)
			cell.cord = board[index]["cord"]
			cell.occupied = board[index]["occupied"]
			cell.object = board[index]["object"]
			cell.object_name = board[index]["object_name"]
			index = index + 1
	######END LOAD CELLS OF THE BOARD
	
	var pieces = json_as_dict["pieces"]
	
	for piece in pieces:
		var piece_scene = load(get_by_id(pieces_db, pieces[piece]["id"])["path"])
		var piece_instance = piece_scene.instantiate()
		board_area.pieces.add_child(piece_instance)
		piece_instance.rotate_piece(pieces[piece]["rotation"])
		piece_instance.position = board_area.position + str_to_var("Vector2" + pieces[piece]["position"])
		piece_instance.ref = board_area
		piece_instance.id = pieces[piece]["id"]
		piece_instance.old_rotation_deg = pieces[piece]["rotation"]
		
		for part in piece_instance.parts:
			var grid_pos = board_area.grid.world_to_grid(part.global_position)
			piece_instance.prev_board_pos.append(grid_pos)
			board_area.grid.grid[grid_pos.x][grid_pos.y].object = piece_instance
	
	for i in board_area.pieces.get_children():
		i.get_neighbours()


func dict_to_board(board_area, dict):
	var board = dict["board"]
	######LOAD CELLS OF THE BOARD
	var index = 0
	for x in board_area.grid.width:
		for y in board_area.grid.height:
			var cell = board_area.grid.get_cell(x,y)
			cell.cord = board[index]["cord"]
			cell.occupied = board[index]["occupied"]
			cell.object = board[index]["object"]
			cell.object_name = board[index]["object_name"]
			index = index + 1
	######END LOAD CELLS OF THE BOARD
	
	var pieces = dict["pieces"]
	
	for piece in pieces:
		var piece_scene = load(get_by_id(pieces_db, pieces[piece]["id"])["path"])
		var piece_instance = piece_scene.instantiate()
		board_area.pieces.add_child(piece_instance)
		piece_instance.rotate_piece(pieces[piece]["rotation"])
		piece_instance.position = board_area.position + pieces[piece]["position"]
		piece_instance.ref = board_area
		piece_instance.offset_pos = piece_instance.position - piece_instance.ref.position
		piece_instance.id = pieces[piece]["id"]
		piece_instance.old_rotation_deg = pieces[piece]["rotation"]
		
		for part in piece_instance.parts:
			var grid_pos = board_area.grid.world_to_grid(part.global_position)
			piece_instance.prev_board_pos.append(grid_pos)
			board_area.grid.grid[grid_pos.x][grid_pos.y].object = piece_instance
	
	for i in board_area.pieces.get_children():
		i.get_neighbours()

func find_by_id(id, db):
	for row in db:
		if row["id"]-1 == id:
			return row

func load_save(save_name):
	var file = "res://Save/"+ save_name +".json"
	var json_as_text = FileAccess.get_file_as_string(file)
	save_file = JSON.parse_string(json_as_text)













