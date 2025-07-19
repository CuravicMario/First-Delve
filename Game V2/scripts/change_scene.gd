extends MenuBtn

@export var TARGET_SCENE:String
@export var exit:bool
@export var tutorial:bool
@export var VIEWPORT:Node

func _physics_process(delta):
	if in_focus:
		if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("interact"):
			AudioMenager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_SELECT)
			if get_tree().paused == true:
				get_tree().paused = false
			if exit:
				get_tree().quit()
			else:				
				if tutorial:
					Global.in_tutorial = true
				else:
					Global.in_tutorial = false
				Style.load_config()
				if !Style.fullscreen:
					VIEWPORT.set_window()
				get_tree().change_scene_to_file(TARGET_SCENE)
