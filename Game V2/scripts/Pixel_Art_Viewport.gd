extends SubViewportContainer

@onready var sub_viewport = $SubViewport
@onready var screen_res = get_viewport().size



var scaling = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)###CODE OR FULLSCREEN
	scaling = Vector2(1600,900) / Vector2(sub_viewport.size.x,sub_viewport.size.y)
	scale = scaling
	
	set_window()
	

func set_window():
	print(Style.fullscreen)
	if Style.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	





