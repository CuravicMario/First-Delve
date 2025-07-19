extends SubViewportContainer

@onready var sub_viewport = $SubViewport
@onready var screen_res = get_viewport().size

# Called when the node enters the scene tree for the first time.
func _ready():
	sub_viewport.size = screen_res
	sub_viewport.transparent_bg = true
	
	#for element in $SubViewport/CanvasLayer.get_children():
	#	var percent_position = Vector2(element.pixel_position.x / 640.0, element.pixel_position.y / 360.0)
	#	print(percent_position)
	#	var real_position = Vector2(screen_res.x * percent_position.x, screen_res.y * percent_position.y)
	#	print(real_position)
	#	element.position = real_position
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
