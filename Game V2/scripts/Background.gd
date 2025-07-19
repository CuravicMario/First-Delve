extends Sprite2D


func _ready():
	self.material.set_shader_parameter("target_color_1", Style.default_primary_color)
	self.material.set_shader_parameter("replace_color_1", Style.primary_color)
	self.material.set_shader_parameter("target_color_2", Style.default_secondery_color)
	self.material.set_shader_parameter("replace_color_2", Style.secondery_color)
