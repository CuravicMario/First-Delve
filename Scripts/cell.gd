extends Node
class_name Cell

var cord
var occupied = false
var object
var object_name


# Called when the node enters the scene tree for the first time.
func _init(x,y):
	cord = Vector2(x,y)

func place(_object):
	occupied = true
	object = _object
	object_name = _object.name

func clear():
	occupied = false
	object = null
	object_name = null
