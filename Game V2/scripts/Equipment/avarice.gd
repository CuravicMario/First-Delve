extends Equipment_Basic

@export var atk_gain = 5
@export var stat_dependent_on_gold:String

var old_gold_value

func add_stats():
	for i in stat_boosts:
		if i == stat_dependent_on_gold:
			old_gold_value = ref.player.player_stats["gold"]
			ref.player.change_base_stats(i, old_gold_value * atk_gain, false)
		else:
			ref.player.change_base_stats(i, stat_boosts[i], false)


func remove_stats():
	for i in stat_boosts:
		if i == stat_dependent_on_gold:
			ref.player.remove_stat(i, old_gold_value * atk_gain)
		else:
			ref.player.remove_stat(i, stat_boosts[i])


func on_end_of_combat():
	ref.player.change_base_stats("gold", 1, false)

func on_gold_changed():
	remove_stats()
	add_stats()

