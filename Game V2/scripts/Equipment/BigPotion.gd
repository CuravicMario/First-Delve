extends Equipment_Basic

@export var heal_perc = 0.15 #in decimal ex. 0.1 for 10%
@export var attack_to_trigger:int
@export var current_attack = 0

# Called when the node enters the scene tree for the first time.
func on_attack():
	
	current_attack +=1
	
	if current_attack == attack_to_trigger:
		ref.player.heal(heal_perc, true)
		current_attack = 0

func on_end_of_combat():
	current_attack = 0
