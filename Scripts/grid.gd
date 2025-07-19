extends Node2D
class_name Grid


var grid = []
var width
var height
var start_pos: Vector2
var cell_size


func _init(_width: int, _height: int, _start_pos: Vector2, _cell_size: int):
	width = _width
	height = _height
	start_pos = _start_pos
	cell_size = _cell_size
	
	for x in range(width): 
		grid.append([])
		for y in range(height): 
			grid[x].append(Cell.new(x,y))
	

func world_to_grid(world_pos):
	var offset_pos = world_pos - start_pos
	
	if outside_of_bounds(world_pos):
		return Vector2(-1,-1)
	
	var x = floor(offset_pos.x/(cell_size))
	var y = floor(offset_pos.y/(cell_size))
	
	return(Vector2(x,y))

func grid_to_world(x,y):
	return(Vector2(start_pos.x + x*(cell_size) + (cell_size)/2,start_pos.y + y*(cell_size) + (cell_size)/2))

func check_cell_occupied(x,y):
	return grid[x][y].occupied

func outside_of_bounds(pos):
	if pos.x < start_pos.x or pos.x > start_pos.x + width*(cell_size):
		return true
	if pos.y < start_pos.y or pos.y > start_pos.y + height*(cell_size):
		return true
	
	return false

func cell_outside_of_bounds(x,y):
	if x < 0 or x >= width:
		return true
	if y < 0 or y >= height:
		return true
	return false

func get_cell(x,y):
	return grid[x][y]




