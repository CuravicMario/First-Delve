extends MenuBtn


func _physics_process(delta):
	if in_focus:
		if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact"):
			AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_SELECT)
			var json_as_dict = Style.load_default()
			print(json_as_dict)
			var file = FileAccess.open("user://default_options_save.json", FileAccess.WRITE_READ)
			var json_string = JSON.stringify(json_as_dict)
			print(json_string)
			file.store_line(json_string)
			file.close()
			
			Style.load_config()
			if !Style.fullscreen:
				$"../../../".set_window()
			get_tree().change_scene_to_file("res://Game V2/Options.tscn")
