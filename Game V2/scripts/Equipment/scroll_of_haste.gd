extends Equipment_Basic

@export var atk_speed_gain = 5
@export var attack_to_trigger:int
@export var current_attack = 1

var num_of_added_azk_speed = 0

# Called when the node enters the scene tree for the first time.
func on_attack():
	
	current_attack +=1
	
	if current_attack == attack_to_trigger:
		
		ref.player.change_base_stats("atkspeed", atk_speed_gain, false)
		num_of_added_azk_speed += 1
		current_attack = 0

func on_end_of_combat():
	current_attack = 0
	
	for i in num_of_added_azk_speed:
		ref.player.remove_stat("atkspeed", atk_speed_gain)
	
	num_of_added_azk_speed = 0
