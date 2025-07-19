extends Node2D

@onready var piece = $".."

func move_one(board, direction):
	var i = get_children()
	var current_cell = board.grid.world_to_grid(i[0].global_position)
	var next_cell = current_cell + direction
	if board.grid.cell_outside_of_bounds(next_cell.x,next_cell.y):
		return
	var temp_position = board.grid.grid_to_world(next_cell.x,next_cell.y)
	piece.position = temp_position - piece.offset_from_part
