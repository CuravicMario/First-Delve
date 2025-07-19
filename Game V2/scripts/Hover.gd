extends Node2D

@onready var box_frame = $HoverBox
@onready var box_fill = $Fill
@onready var box_tail = $Tail
@onready var out_of_bounds_notifier = $"Top notifier"

# Called when the node enters the scene tree for the first time.
func _ready():
	box_fill.scale = box_frame.get_used_rect().size * box_frame.tile_set.tile_size.x -  Vector2i(2,2)
	
	box_frame.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	box_frame.material.set_shader_parameter("replace_color_1", Style.primary_color)
	box_frame.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	box_frame.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	box_fill.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	box_fill.material.set_shader_parameter("replace_color_1", Style.primary_color)
	box_fill.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	box_fill.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	box_tail.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	box_tail.material.set_shader_parameter("replace_color_1", Style.primary_color)
	box_tail.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	box_tail.material.set_shader_parameter("replace_color_2", Style.secondery_color)



