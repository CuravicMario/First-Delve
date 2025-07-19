extends Focus

var pieces_focus = []
@onready var board = $"../PlayerBoard"
#@onready var info_bar = $"../Info bar"

@export var PLAYER:bool = false
@export var SHOP:bool = false

var sub_focus
var in_focus = false
var active = false
var holding = false
var piece_held


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_focus:
		if active:
			if holding:
				if Input.is_action_just_pressed("up"):
					piece_held.parts_container.move_one(board, Vector2(0,-1))
				if Input.is_action_just_pressed("down"):
					piece_held.parts_container.move_one(board, Vector2(0,1))
				if Input.is_action_just_pressed("left"):
					piece_held.parts_container.move_one(board, Vector2(-1,0))
				if Input.is_action_just_pressed("right"):
					piece_held.parts_container.move_one(board, Vector2(1,0))
				if Input.is_action_just_pressed("interact"):
					piece_held.start_insert()
					holding = false
					piece_held = null
				if Input.is_action_just_pressed("rotate"):
					piece_held.rotate_piece_keyboard(piece_held.rotation_deg + 90)
				if Input.is_action_just_pressed("sell"):
					board.player.change_base_stats("gold",Global.get_by_id(Global.equipment_db, piece_held.id)["rarity"])
					holding = false
					active = false
					Global.in_sub_focus = false
					sub_focus.unfocus()
					sub_focus = null
					piece_held.queue_free()
			else:
				if Input.is_action_just_pressed("up"):
					get_next_y(sub_focus, -1)
				if Input.is_action_just_pressed("down"):
					get_next_y(sub_focus, 1)
				if Input.is_action_just_pressed("left"):
					get_next_x(sub_focus, -1)
				if Input.is_action_just_pressed("right"):
					get_next_x(sub_focus, 1)
				if Input.is_action_just_pressed("interact") and board.player.can_move_items:
					holding = true
					piece_held = sub_focus
					piece_held.clear_board_position()
					piece_held.label.visible = false
					piece_held.info_hover.visible = false
					piece_held.initial_pos =  piece_held.position
						
				if Input.is_action_just_pressed("cancel"):
					active = false
					Global.in_sub_focus = false
					sub_focus.unfocus()
					sub_focus = null
					
		else:
			if Input.is_action_just_pressed("interact"):
				selected()
				Global.in_sub_focus = true



func selected():
	for x in board.WIDTH:
		for y in board.HEIGHT:
			if board.grid.grid[x][y].occupied:
				sub_focus = board.grid.grid[x][y].object
				sub_focus.focus()
				active = true
				return
	

func focus():
	in_focus = true
	board.outline.visible = true

func unfocus():
	if !sub_focus == null:
		sub_focus.unfocus()
		sub_focus = null
	if holding:
		piece_held.start_insert()
		piece_held.scale = Vector2(1,1)
		holding = false
		piece_held = null
	board.outline.visible = false
	in_focus = false
	active = false
	

func get_next_x(piece, prefix):
	var min_x = 100
	var max_x = 0
	
	for part in piece.parts:
		var cell = board.grid.world_to_grid(part.global_position)
		
		if cell.x > max_x:
			max_x = cell.x
		if cell.x < min_x:
			min_x = cell.x
		
		var temp_x = cell.x + prefix
		while temp_x >= 0 and temp_x < board.WIDTH:
			var potential_next = board.grid.get_cell(temp_x, cell.y)
			if potential_next.occupied and !(potential_next.object == piece):
				sub_focus.unfocus()
				sub_focus = potential_next.object
				sub_focus.focus()
				return
			temp_x = temp_x + prefix
	
	
	if prefix > 0:
		for x in range(max_x + 1, board.WIDTH):
			for y in board.HEIGHT:
				var potential_next = board.grid.get_cell(x, y)
				if potential_next.occupied and !(potential_next.object == piece):
					sub_focus.unfocus()
					sub_focus = potential_next.object
					sub_focus.focus()
					return
	else:
		for x in range(0, min_x):
			for y in board.HEIGHT:
				var potential_next = board.grid.get_cell(x, y)
				if potential_next.occupied and !(potential_next.object == piece):
					sub_focus.unfocus()
					sub_focus = potential_next.object
					sub_focus.focus()
					return


func get_next_y(piece, prefix):
	var min_y = 100
	var max_y = 0
	
	for part in piece.parts:
		var cell = board.grid.world_to_grid(part.global_position)
		
		if cell.y > max_y:
			max_y = cell.y
		if cell.y < min_y:
			min_y = cell.y
		
		var temp_y = cell.y + prefix
		while temp_y >= 0 and temp_y < board.HEIGHT:
			var potential_next = board.grid.get_cell(cell.x, temp_y)
			if potential_next.occupied and potential_next.object != piece:
				sub_focus.unfocus()
				sub_focus = potential_next.object
				sub_focus.focus()
				return
			temp_y = temp_y + prefix
	
	if prefix > 0:
		for y in range(max_y + 1, board.HEIGHT):
			for x in board.WIDTH:
				var potential_next = board.grid.get_cell(x, y)
				if potential_next.occupied and !(potential_next.object == piece):
					sub_focus.unfocus()
					sub_focus = potential_next.object
					sub_focus.focus()
					return
	else:
		for y in range(0, min_y):
			for x in board.WIDTH:
				var potential_next = board.grid.get_cell(x, y)
				if potential_next.occupied and !(potential_next.object == piece):
					sub_focus.unfocus()
					sub_focus = potential_next.object
					sub_focus.focus()
					return

func _on_child_order_changed():
	pieces_focus = get_children()



func _on_child_entered_tree(node):
	$"../RoomSelect".can_leave = true
