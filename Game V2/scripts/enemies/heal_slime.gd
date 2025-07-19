extends BaseEnemy

@onready var parent = $".."

func heal_enemy():
	var healed = false
	for i in parent.get_children():
		if i.current_hp < i.enemy_info["hp"]:
			i.heal(enemy_info["atk"])
			healed = true
	
	if not healed:
		player.take_dmg(enemy_info["atk"])

func _on_atk_progress_timeout():
	heal_enemy()
	atk_timer.start()

