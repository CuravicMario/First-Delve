extends Equipment_Basic

@export var dmg = 10
@export var attack_to_trigger:int
@export var current_attack = 0

# Called when the node enters the scene tree for the first time.
func on_attack():
	
	current_attack +=1
	
	if current_attack == attack_to_trigger:
		if not ref.player.list_of_enemies.size() == 0:
			ref.player.list_of_enemies[ref.player.list_of_enemies.size()-1].take_dmg(dmg)
		current_attack = 0


func on_end_of_combat():
	current_attack = 0
