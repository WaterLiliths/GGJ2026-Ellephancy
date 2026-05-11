shader_type canvas_item;
render_mode blend_add;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_size : hint_range(0.0, 20.0) = 6.0;
uniform float strength : hint_range(0.0, 2.0) = 0.5;
uniform float threshold : hint_range(0.0, 1.0) = 0.5;

vec4 extract_bright(vec2 uv) {
    vec4 col = texture(SCREEN_TEXTURE, uv);
    float brightness = dot(col.rgb, vec3(0.2126, 0.7152, 0.0722));
    return col * smoothstep(threshold - 0.1, threshold + 0.1, brightness);
}

void fragment() {
    vec2 ps = SCREEN_PIXEL_SIZE * blur_size;

    vec4 col = vec4(0.0);
    float total = 0.0;

    // Blur the bright-extracted pixels, not the masked result
    for (int x = -4; x <= 4; x++) {
        for (int y = -4; y <= 4; y++) {
            float weight = exp(-float(x*x + y*y) / 8.0);
            col += extract_bright(SCREEN_UV + vec2(float(x), float(y)) * ps) * weight;
            total += weight;
        }
    }
    col /= total;

    COLOR = col * strength;
}
