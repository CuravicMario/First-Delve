extends Node2D
class_name Equipment_Basic

var offset_pos

var draggable = false
var is_inside_dropable = false
var can_be_sold = false
var focussed_on = false
var purchesed = true
var ref
var offset: Vector2
var parts
var offset_from_part

var initial_pos
var rotation_deg = 0
var old_rotation_deg = 0

var prev_board_pos = []

var enemy

var neighbours = []

@onready var collision_shape = $Area2D/CollisionPolygon2D
@onready var self_path = self.name
@onready var parts_container = $Parts
@onready var collision_polygon = $Area2D/CollisionPolygon2D
@onready var info_hover = $Hover
@onready var hover_border = $Hover_border
@onready var default_position = $DefaultPosition
@onready var switch_position = $SwitchPosition
@onready var player_storage = $"../../pieces"

var id
var eq_name
var rarity
var label
var label_size = Vector2(124,60)
var label_group = "equipment"
var moving = false
var in_focus = false

signal piece_hover(_description)

@export var stat_boosts = {
	"hp": 0,
	"atk": 0,
	"atkspeed": 0,
	"crit": 0,
	"critamp": 0,
	"armor": 0,
	"lifesteal": 0,
	"dodge": 0
}


func create_equipment(_stats_boosts):
	var rarity_data = Global.get_by_id(Global.rarity_db, rarity)
	var _color = Color.html(rarity_data["color"])
	
	var equipment_data = Global.get_by_id(Global.equipment_db, id)
	eq_name = equipment_data["name"]
	
	
	stat_boosts = _stats_boosts


func set_stats():
	var equipment_data = Global.get_by_id(Global.equipment_db, id)
	for i in stat_boosts:
		
		match int(equipment_data[i]):
			0:
				pass
			1:
				var range_string = Global.get_db_row(Global.stats_db, "name", i)["primary"]
				var lower_limit = int(range_string.split("-")[0])
				var upper_limit = int(range_string.split("-")[1])
				
				var stat_num = Global.random.randi_range(lower_limit,upper_limit)
				stat_boosts[i] = stat_num
			2:
				var range_string = Global.get_db_row(Global.stats_db, "name", i)["secondary"]
				var lower_limit = int(range_string.split("-")[0])
				var upper_limit = int(range_string.split("-")[1])
				
				var stat_num = Global.random.randi_range(lower_limit,upper_limit)
				stat_boosts[i] = stat_num
			3:
				var range_string = Global.get_db_row(Global.stats_db, "name", i)["tertiary"]
				var lower_limit = int(range_string.split("-")[0])
				var upper_limit = int(range_string.split("-")[1])
				
				var stat_num = Global.random.randi_range(lower_limit,upper_limit)
				stat_boosts[i] = stat_num


func _ready():
	label = get_tree().get_first_node_in_group(label_group)
	label.resize_self(label_size)
	label.text.get_theme_stylebox("normal").bg_color = Style.secondery_color
	label.visible = false
	
	parts = parts_container.get_children()
	offset_from_part = parts[0].position
	
	hover_border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	hover_border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	hover_border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	hover_border.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	for i in parts_container.get_children():
		i.material.set_shader_parameter("target_color_1", Style.default_primary_color)
		i.material.set_shader_parameter("replace_color_1", Style.primary_color)
		i.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
		i.material.set_shader_parameter("replace_color_2", Color.html(Style.rarity[int(rarity)]))
	
	pass#print(id)


func _process(delta):
	if draggable  and not Global.item_not_unlocked:
		if Input.is_action_just_pressed("click") and ref.player.can_move_items:
			moving = true
			info_hover.visible = false
			label.visible = false
			
			self.z_index = 50
			offset = get_global_mouse_position() - self.position
			initial_pos =  self.position
			Global.is_dragging = true
			clear_board_position()
		if Input.is_action_pressed("click") and moving:
			self.position = lerp(position, get_global_mouse_position(),1)
			
			if Input.is_action_just_pressed("rotate"):
				rotate_piece(rotation_deg + 90)
			if Input.is_action_just_pressed("ui_cancel"):
				self.queue_free()
			
		elif Input.is_action_just_released("click") and moving:
			Global.is_dragging = false
			
			if is_inside_dropable:
				start_insert()
			elif can_be_sold:
				ref.player.change_base_stats("gold",rarity, false)
				self.queue_free()
			else:
				if !purchesed:
					self.queue_free()
				else:
					rotate_piece(old_rotation_deg)
					var tween = get_tree().create_tween()
					tween.tween_property(self,"position",initial_pos,0.2).set_ease(Tween.EASE_OUT)
					tween.connect("finished", on_tween_finished)
			
			
		

func asign_stats():
	var equipment = Global.get_by_id(Global.equipment_db, id)
	stat_boosts["hp"] = equipment["hp"]
	stat_boosts["atk"] = equipment["atk"]
	stat_boosts["atkspeed"] = equipment["atkspeed"]
	stat_boosts["crit"] = equipment["crit"]
	stat_boosts["lifesteal"] = equipment["lifesteal"]
	stat_boosts["dodge"] = equipment["dodge"]


func start_insert():
	var tween = get_tree().create_tween()
	var pos = insert()
	if pos == initial_pos:
		if !purchesed:
			self.queue_free()
		else:
			rotate_piece(old_rotation_deg)
			return_to_pos()
			unfocus()
			draggable = false
	for i in ref.pieces.get_children():
		i.get_neighbours()
	tween.tween_property(self,"position",pos,0.2).set_ease(Tween.EASE_OUT)
	tween.connect("finished", on_tween_finished)
	purchesed = true
	add_stats()

func insert():
	var new_part_positions = []
	var new_pos
	
	
	self.z_index = 0
	
	for i in parts:
		var cell = ref.grid.world_to_grid(i.global_position)
		if cell == Vector2(-1,-1):
			return initial_pos
		if ref.grid.check_cell_occupied(cell.x,cell.y):
			return initial_pos
		else:
			new_part_positions.append(ref.grid.grid_to_world(cell.x,cell.y))
			
	
	new_pos = new_part_positions[0] - offset_from_part
	prev_board_pos.clear()
	for i in new_part_positions:
		var cell = ref.grid.world_to_grid(i)
		ref.grid.grid[cell.x][cell.y].place(self)
		prev_board_pos.append(cell)
	
	self.reparent(player_storage)
	
	old_rotation_deg = rotation_deg
	offset_pos = new_pos - ref.position
	return new_pos

func rotate_piece(new_rotation_deg:int):
	hover_border.rotation_degrees += new_rotation_deg
	var rotation_diff = abs(new_rotation_deg - rotation_deg) / 90
	
	for step in range(rotation_diff):
		for i in parts:
			i.position = rotate_point(i.position, 90)
			i.rotate(deg_to_rad(90))
		var new_polygon = collision_shape.polygon
		for i in (new_polygon.size()):
			new_polygon[i] = rotate_point(new_polygon[i], 90)
		collision_shape.polygon = new_polygon
		offset_from_part = parts[0].position
		
	rotation_deg = new_rotation_deg % 360

func rotate_piece_keyboard(new_rotation_deg:int):
	hover_border.rotation_degrees += 90
	var rotation_diff = abs(new_rotation_deg - rotation_deg) / 90
	var offsets = []
	var new_origin = rotate_around_point(Vector2(0,0), 90, parts[0].position)
	
	for step in range(rotation_diff):
		position = rotate_around_point(position, 90, parts[0].global_position)
		for i in parts:
			i.position = rotate_point(i.position, 90)
			i.rotate(deg_to_rad(90))
		var new_polygon = collision_shape.polygon
		for i in (new_polygon.size()):
			new_polygon[i] = rotate_point(new_polygon[i], 90)
		collision_shape.polygon = new_polygon
		offset_from_part = parts[0].position
		
	rotation_deg = new_rotation_deg % 360

func rotate_point(point:Vector2, deg:int):
	var new_x = point.x * cos(deg_to_rad(deg)) - point.y * sin(deg_to_rad(deg))
	var new_y = point.x * sin(deg_to_rad(deg)) + point.y * cos(deg_to_rad(deg))
	
	return(Vector2(new_x,new_y))

func rotate_around_point(point:Vector2, deg:int, pivot:Vector2):
	var new_origin = point - pivot
	var new_x = new_origin.x * cos(deg_to_rad(deg)) - new_origin.y * sin(deg_to_rad(deg))
	var new_y = new_origin.x * sin(deg_to_rad(deg)) + new_origin.y * cos(deg_to_rad(deg))	
	
	return(Vector2(new_x + pivot.x, new_y + pivot.y))

func clear_board_position():
	remove_stats()
	for cell in prev_board_pos:
		ref.grid.grid[cell.x][cell.y].clear()

func return_to_pos():
	for cell in prev_board_pos:
		ref.grid.grid[cell.x][cell.y].place(self)


func effect():
	pass

func get_neighbours():
	for i in parts:
		var grid_pos = ref.grid.world_to_grid(i.global_position)
		var neighbouring_cells = [Vector2(1, 0),Vector2(-1, 0),Vector2(0, 1),Vector2(0, -1)]
		for neighbour in neighbouring_cells:
			if !ref.grid.cell_outside_of_bounds(grid_pos.x + neighbour.x, grid_pos.y + neighbour.y):
				var cell = ref.grid.get_cell(grid_pos.x + neighbour.x, grid_pos.y + neighbour.y)
				if cell.occupied:
					if !cell.object == self:
						if !neighbours.has(cell.object):
							neighbours.append(cell.object)

func add_stats():
	for i in stat_boosts:
		ref.player.change_base_stats(i, stat_boosts[i], false)

func remove_stats():
	for i in stat_boosts:
		ref.player.remove_stat(i, stat_boosts[i])

func remove_piece():
	remove_stats()
	self.queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		ref = body
	if body.is_in_group("sell"):
		can_be_sold = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = false
	if body.is_in_group("sell"):
		can_be_sold = false

func _on_area_2d_mouse_entered():
	if not Global.is_dragging and not Global.combat_end and not moving and !Global.tutorial:
		draggable = true
		focus()

func _on_area_2d_mouse_exited():
	if not Global.is_dragging and not Global.combat_end and not moving and !Global.tutorial:
		draggable = false
		unfocus()



func focus():
	var piece = Global.get_by_id(Global.equipment_db, id)
	in_focus = true
	if info_hover.out_of_bounds_notifier.global_position.y < 8:
		switch_hover_info()
	
	label.equipment_emmiting = self
	label.visible = true
	label.position_self(self.position + info_hover.position)
	
	var description = "[color="+Style.primary_color.to_html(false)+"][center][b][font_size=32]%s[/font_size][/b]" % Global.get_by_id(Global.equipment_db, id)["name"]
	description += "\n[img=38 color="+Style.rarity_default[int(rarity)]+"]res://Game V2/Sprites/Equipment divider.png[/img][/center]\n"
	description += "%s[/color]" % TextManager.equipment_description(id)
	
	label.text.text = description
	info_hover.visible = true
	hover_border.visible = true
	print(info_hover.out_of_bounds_notifier.global_position)
	#scale = Vector2(1.05,1.05)
	#piece_hover.emit(TextManager.equipment_discription(stat_boosts,eq_name), load("res://Sprites/equipment/"+piece["name"]+"-Final.png"))
	#z_index = 50

func unfocus():
	info_hover.visible = false
	hover_border.visible = false
	info_hover.rotation_degrees = 0
	info_hover.position = default_position.position
	in_focus = false
		
	if label.equipment_emmiting == self:
		label.visible = false
	#scale = Vector2(1,1)
	pass#z_index = 0

func switch_hover_info():
	info_hover.rotation_degrees = 180
	info_hover.position = switch_position.position


func on_tween_finished():
	if in_focus:
		focus()
	moving = false

func _on_area_2d_area_entered(area):	
	if area.is_in_group("sell"):
		can_be_sold = true


func _on_area_2d_area_exited(area):
	if area.is_in_group("sell"):
		can_be_sold = false
