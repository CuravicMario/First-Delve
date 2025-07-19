shader_type canvas_item;
 
uniform vec4 target_color_1 : source_color;
uniform vec4 replace_color_1 : source_color; 
uniform vec4 target_color_2 : source_color;
uniform vec4 replace_color_2 : source_color; 
uniform float tolerance : hint_range(0, 1); 
 
void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
 
    float dist_1 = distance(tex_color.rgb, target_color_1.rgb);
    float dist_2 = distance(tex_color.rgb, target_color_1.rgb);
 
    /*if (dist_1 < tolerance) {
        tex_color.rgb = replace_color_1.rgb;
    }*/
	
	if (tex_color.rgb == target_color_1.rgb) {
		tex_color.rgb = replace_color_1.rgb;
	}
	
	if (tex_color.rgb == target_color_2.rgb) {
		tex_color.rgb = replace_color_2.rgb;
	}
 
    COLOR = tex_color;
}