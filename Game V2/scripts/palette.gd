extends Node2D

var half_sq_size = 8
var old_chosen
var chosen

enum PALETT_TYPE {
	primary,
	secondary,
	hp,
	common,
	rare,
	legendary
}

@onready var palette_sq = load("res://Game V2/Scenes/palette_sq.tscn")

@export var type: PALETT_TYPE
@export var UP: Node
@export var DOWN: Node
@export var LEFT: Node

func _ready():
	var count = 0
	for i in Style.palett:
		var temp_sq = palette_sq.instantiate()
		
		add_child(temp_sq)
		
		temp_sq.position = Vector2(half_sq_size + (3*count*half_sq_size), half_sq_size)
		temp_sq.sq.modulate = Color.html(i)
		temp_sq.color = Color.html(i)
		
		match type:
			PALETT_TYPE.primary:
				if Color.html(i) == Style.primary_color:
					old_chosen = temp_sq
					chosen = temp_sq
					temp_sq.chosen.visible = true
			PALETT_TYPE.secondary:
				if Color.html(i) == Style.secondery_color:
					old_chosen = temp_sq
					chosen = temp_sq
					temp_sq.chosen.visible = true
			PALETT_TYPE.hp:
				if Color.html(i) == Style.hp_color:
					old_chosen = temp_sq
					chosen = temp_sq
					temp_sq.chosen.visible = true
			PALETT_TYPE.common:
				if Color.html(i) == Color.html(Style.rarity[1]):
					old_chosen = temp_sq
					chosen = temp_sq
					temp_sq.chosen.visible = true
			PALETT_TYPE.rare:
				if Color.html(i) == Color.html(Style.rarity[2]):
					old_chosen = temp_sq
					chosen = temp_sq
					temp_sq.chosen.visible = true
			PALETT_TYPE.legendary:
				if Color.html(i) == Color.html(Style.rarity[3]):
					old_chosen = temp_sq
					chosen = temp_sq
					temp_sq.chosen.visible = true
		
		
		
		count += 1
	
	
	assaign_neighbours()
	

func assaign_neighbours():
	var all_sqs = get_children()
	var size = all_sqs.size()
	
	UP.DOWN_NEIGHBOUR = all_sqs[0]
	DOWN.UP_NEIGHBOUR = all_sqs[0]
	
	for i in size:
		all_sqs[i].UP_NEIGHBOUR = UP
		all_sqs[i].DOWN_NEIGHBOUR = DOWN
		if i == 0:
			all_sqs[i].LEFT_NEIGHBOUR = LEFT
		if not(i == 0):
			all_sqs[i].LEFT_NEIGHBOUR = all_sqs[i-1]
		if not(i == size - 1):
			all_sqs[i].RIGHT_NEIGHBOUR = all_sqs[i+1]

func choose_this(chosen_sq):
	chosen = chosen_sq
	old_chosen.chosen.visible = false
	chosen.chosen.visible = true
	old_chosen = chosen

func do_show():
	visible = true

func dont_show():
	visible = false


