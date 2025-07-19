extends CharacterBody2D

@export var WIDTH:int
@export var HEIGHT:int
@export var CELL_SIZE:int


@onready var pieces = $"../pieces"
@onready var outline = $Hover_border
@onready var board_sprite = $BoardSprite
@onready var player = $"../PlayerSprite"
@onready var tutorial = $"../Tutorial"

var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = Grid.new(WIDTH, HEIGHT, self.position, CELL_SIZE)
	
	if Global.in_tutorial:
		Global.focus_points = tutorial.next_arrow
	else:
		Global.focus_points = pieces
	if Global.keyboard_input or Style.default_keyboard:
		Global.keyboard_input = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Global.current_focus = Global.focus_points
		Global.current_focus.focus()
	
	outline.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	outline.material.set_shader_parameter("replace_color_1", Style.primary_color)
	outline.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	outline.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	board_sprite.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	board_sprite.material.set_shader_parameter("replace_color_1", Style.primary_color)
	board_sprite.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	board_sprite.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	create_item_on_board(11)
	create_item_on_board(12)
	create_item_on_board(14)
	create_item_on_board(5)

func create_item_on_board(id):
	var temp_piece = load(Global.get_by_id(Global.equipment_db,id)["path"]).instantiate()
	temp_piece.id = Global.get_by_id(Global.equipment_db,id)["id"]
	temp_piece.rarity = Global.get_by_id(Global.equipment_db,id)["rarity"]
	#temp_piece.create_equipment(stat_boosts)
	pieces.add_child(temp_piece)
	temp_piece.position = place_on_board(temp_piece)
	temp_piece.ref = self
	temp_piece.asign_stats()
	temp_piece.start_insert()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func place_on_board(piece):
	print("PLACING")
	print(piece)
	var parts_relations = []
	var base_part = piece.parts_container.get_children()[0]
	for part in piece.parts_container.get_children():
		if !part == base_part:
			var position_diff = (base_part.position - part.position)/32
			parts_relations.append(position_diff)
	print(parts_relations)
	for x in grid.width:
		for y in grid.height:
			var place = true
			var start_cell = Vector2(x,y)
			if !grid.check_cell_occupied(start_cell.x,start_cell.y):
				for i in parts_relations:
					var next_cell = start_cell - i
					if grid.cell_outside_of_bounds(next_cell.x,next_cell.y):
						place = false
					else:
						if grid.check_cell_occupied(next_cell.x,next_cell.y): 
							place = false
			else:
				place = false
			
			if place:
				return grid.grid_to_world(start_cell.x,start_cell.y) - piece.offset_from_part







