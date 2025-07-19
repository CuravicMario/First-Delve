extends Node2D

enum SOUND_TYPE{
	bg,
	sfx
}

@onready var bar_visualisation = $Border/TextureProgressBar

@export var TYPE:SOUND_TYPE

# Called when the node enters the scene tree for the first time.
func _ready():
	match TYPE:
		SOUND_TYPE.bg:
			bar_visualisation.value = Style.background_volume
		SOUND_TYPE.sfx:
			bar_visualisation.value = Style.sfx_volume


func rise():
	bar_visualisation.value +=1
	match TYPE:
		SOUND_TYPE.bg:
			AudioMenager.change_bg_volume(bar_visualisation.value)
		SOUND_TYPE.sfx:
			AudioMenager.change_sfx_volume(bar_visualisation.value)

func lower():
	bar_visualisation.value -=1
	match TYPE:
		SOUND_TYPE.bg:
			AudioMenager.change_bg_volume(bar_visualisation.value)
		SOUND_TYPE.sfx:
			AudioMenager.change_sfx_volume(bar_visualisation.value)

func do_show():
	visible = true

func dont_show():
	visible = false
