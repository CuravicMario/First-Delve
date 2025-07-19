extends Node2D

@export var shop_slots:Array[Node]
@export var unsold_items:Node
@export var label_group:String

var price_labels

@onready var room_complete_btn = $"Room Complete"
@onready var reroll = $Reroll
@onready var pieces = $"../pieces"
@onready var player = $"../PlayerSprite"
@onready var sell = $Sell
@onready var border = $Border
@onready var lowest_elements = [$"Room Complete"]
@onready var tutorial = $"../Tutorial"

# Called when the node enters the scene tree for the first time.
func _ready():
	border.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	border.material.set_shader_parameter("replace_color_1", Style.primary_color)
	border.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	border.material.set_shader_parameter("replace_color_2", Style.secondery_color)
	
	price_labels = get_tree().get_nodes_in_group(label_group)
	var count = 0
	for i in shop_slots:
		price_labels[count].position_self(self.position + i.position + i.price_sign.position + i.price_sign.price_pos.position)
		count += 1

func stock_shop():
	clear_shop()
	print("STOCKING")
	var count = 0
	for i in shop_slots:
		var item_id = choose_an_item()
		var item = load(Global.get_by_id(Global.equipment_db, item_id)["path"]).instantiate()
		item.id = item_id
		item.rarity = Global.get_by_id(Global.equipment_db, item_id)["rarity"]
		i.item = item
		item.asign_stats()
		
		unsold_items.add_child(item)
		item.position = i.global_position
		price_labels[count].text.text = "[color="+Style.primary_color.to_html(false)+"][b][font_size=32][center][img=32 color="+Style.primary_color.to_html(false)+"]res://Game V2/Sprites/info icon gold.png[/img]" + str(item.rarity*2) + "[/center][/font_size][/b][/color]"
		count += 1

func choose_an_item():	
	var possible_rewards_common_ids = Global.get_equipment_of_rarity(1)
	var possible_rewards_rare_ids = Global.get_equipment_of_rarity(2)
	
	#Goose wich rarity based on rhe floor
	var choose_rarity = Global.random.randi_range(0,100)
	
	var chosen_reward_id
	
	if choose_rarity < 85:
		chosen_reward_id = Global.random.randi_range(0, possible_rewards_common_ids.size()-1)
		return possible_rewards_common_ids[chosen_reward_id]
	else:
		chosen_reward_id = Global.random.randi_range(0, possible_rewards_rare_ids.size()-1)
		return possible_rewards_rare_ids[chosen_reward_id]
	
	

func activate():
	stock_shop()
	room_complete_btn.do_show()
	self.visible = true
	reroll.label.visible = true
	sell.label.visible = true
	pieces.UP_NEIGHBOUR = lowest_elements[0]
	for i in lowest_elements:
		i.DOWN_NEIGHBOUR = pieces
	for i in price_labels:
		i.visible = true
	
	if Global.in_tutorial:
		tutorial.open_tutorial()

func deactivate():
	clear_shop()
	room_complete_btn.dont_show()
	self.visible = false
	reroll.label.visible = false
	sell.label.visible = false
	for i in price_labels:
		i.visible = false

func clear_shop():
	for i in unsold_items.get_children():
		i.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
