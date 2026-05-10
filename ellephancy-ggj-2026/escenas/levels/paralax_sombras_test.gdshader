shader_type canvas_item;
render_mode unshaded;

uniform float brightness : hint_range(0.0, 4.0) = 1.5;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    COLOR = vec4(col.rgb * brightness, col.a);
}
