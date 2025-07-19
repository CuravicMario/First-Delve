extends Node


var random = RandomNumberGenerator.new()

var enemies
var combat_encounters


# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	var file = "res://Game V2/Databases/enemies.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	enemies = JSON.parse_string(json_as_text)
	
	
	file = "res://Game V2/Databases/combat_encounters.json"
	json_as_text = FileAccess.get_file_as_string(file)
	combat_encounters = JSON.parse_string(json_as_text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_row_by_id(db, id):
	for i in db.size():
		if db[i]["id"] == id:
			return db[i]

