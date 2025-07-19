extends Equipment_Basic

@export var stat_to_reduce:String

func add_stats():
	for i in stat_boosts:
		if i == stat_to_reduce:
			ref.player.remove_stat(i, stat_boosts[i])
		else:
			ref.player.change_base_stats(i, stat_boosts[i], false)


func remove_stats():
	for i in stat_boosts:
		if i == stat_to_reduce:
			ref.player.change_base_stats(i, stat_boosts[i], false)
		else:
			ref.player.remove_stat(i, stat_boosts[i])


