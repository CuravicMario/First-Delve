extends Node

@export var falling_curve: Curve2D

@onready var number_label = load("res://Game V2/Scenes/UI_number.tscn")

var range_min = -8
var range_max = 8

# Called when the node enters the scene tree for the first time.
func display_number(value, position, is_gold, canvas):
	var temp_num = number_label.instantiate()
	canvas.add_child(temp_num)
	
	var rand_num = Global.random.randi_range(range_min, range_max)
	
	temp_num.position_self(position + Vector2(rand_num,abs(rand_num)))
	
	if is_gold:
		temp_num.modulate = Style.primary_color
	else:
		temp_num.modulate = Style.hp_color
	
	temp_num.text = str(value)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		temp_num, "position:y", temp_num.position.y - 32, 0.5
	).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(temp_num, "position:y", temp_num.position.y, 0.5).set_ease(Tween.EASE_IN_OUT).set_delay(0.25)
	#tween.tween_property(temp_num, "scale", Vector2.ZERO, 0.25).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	temp_num.queue_free()
	




