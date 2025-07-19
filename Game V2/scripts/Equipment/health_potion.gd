extends Equipment_Basic

@export var heal_ammount = 10
@export var attack_to_trigger:int
@export var current_attack = 0

# Called when the node enters the scene tree for the first time.
func on_attack():
	
	current_attack +=1
	
	if current_attack == attack_to_trigger:
		ref.player.heal(heal_ammount, false)
		current_attack = 0

func on_end_of_combat():
	current_attack = 0
