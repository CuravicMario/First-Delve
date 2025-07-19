extends MenuBtn

@export var palette_1:Node
@export var palette_2:Node
@export var hp_palette:Node
@export var common_palette:Node
@export var rare_palette:Node
@export var legendary_palette:Node
@export var keyboard:Node
@export var fullscreen:Node
@export var background_volume:Node
@export var sfx_volume:Node
@export var hotkeys:Node
@export var lang:Node

func _physics_process(delta):
	if in_focus:
		if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact"):
			AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_SELECT)
			save_config()
			Style.load_config()
			if !Style.fullscreen:
				$"../../../".set_window()
			get_tree().change_scene_to_file("res://Game V2/Options.tscn")

func save_config():
	var file = FileAccess.open("user://options_save.json", FileAccess.WRITE_READ)
	var save_dict = {
		"primary": palette_1.chosen.color.to_html(false),
		"secondary": palette_2.chosen.color.to_html(false),
		"hp": hp_palette.chosen.color.to_html(false),
		"fullscreen": fullscreen.ticked,
		"background_volume": background_volume.bar_visualisation.value,
		"sfx_volume": sfx_volume.bar_visualisation.value,
		"common_color": common_palette.chosen.color.to_html(false),
		"rare_color": rare_palette.chosen.color.to_html(false),
		"legendary_color": legendary_palette.chosen.color.to_html(false),
		"default_keyboard": keyboard.ticked,
		"lang": lang.languages[lang.value]
	}
	
	var hotkey_dict = {}
	for i in hotkeys.get_children():
		hotkey_dict[i.action] = str(InputMap.action_get_events(i.action)[0].as_text_physical_keycode())
	
	save_dict.merge(hotkey_dict)
	
	var json_string = JSON.stringify(save_dict)
	file.store_line(json_string)


