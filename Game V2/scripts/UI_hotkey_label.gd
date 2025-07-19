extends HBoxContainer

var screen_res = Vector2(1600,900)

@onready var action_name = $Name
@onready var button = $Action

# Called when the node enters the scene tree for the first time.
func position_self(_pixel_position):
	var percent_position = Vector2(_pixel_position.x / 640.0, _pixel_position.y / 360.0)
	var real_position = Vector2(screen_res.x * percent_position.x, screen_res.y * percent_position.y)
	position = real_position - self.size/2

func resize_self(_pixel_size):
	var percent_size = Vector2(_pixel_size.x / 640.0, _pixel_size.y / 360.0)
	var real_size = Vector2(screen_res.x * percent_size.x, screen_res.y * percent_size.y)
	size = real_size
