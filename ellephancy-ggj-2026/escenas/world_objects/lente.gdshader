shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform float refraction_strength : hint_range(0.0, 0.05) = 0.015;
uniform float ca_strength : hint_range(0.0, 0.03) = 0.008;
uniform float edge_fresnel : hint_range(0.0, 1.0) = 0.6;
uniform float edge_sharpness : hint_range(1.0, 8.0) = 3.0;
uniform float tint_strength : hint_range(0.0, 1.0) = 0.08;
uniform vec4 glass_tint : source_color = vec4(0.85, 0.95, 1.0, 1.0);
uniform float gloss : hint_range(0.0, 1.0) = 0.15;
uniform float flicker_speed : hint_range(0.0, 10.0) = 1.5;
uniform float flicker_amount : hint_range(0.0, 0.2) = 0.04;

void fragment() {
    vec2 uv = UV - 0.5;

    vec4 sprite = texture(TEXTURE, UV);
    float mask = sprite.a;

    float dist = length(uv * 2.0);

    float shimmer = 1.0 + flicker_amount * sin(TIME * flicker_speed + uv.x * 4.0 + uv.y * 3.0);

    vec2 normal_approx = uv * (1.0 - dist * 0.3);
    vec2 refract_offset = normal_approx * refraction_strength * shimmer;

    vec2 screen_uv = SCREEN_UV;
    vec2 ca_offset = normalize(uv + vec2(0.001)) * ca_strength;

    vec4 screen_r = texture(screen_texture, screen_uv + refract_offset + ca_offset);
    vec4 screen_g = texture(screen_texture, screen_uv + refract_offset);
    vec4 screen_b = texture(screen_texture, screen_uv + refract_offset - ca_offset);

    vec3 refracted = vec3(screen_r.r, screen_g.g, screen_b.b);
    refracted = mix(refracted, refracted * glass_tint.rgb, tint_strength);

    float edge = pow(dist, edge_sharpness) * edge_fresnel;

    float spec_angle = sin(TIME * 0.4) * 0.5 + 0.5;
    float spec = pow(max(0.0, dot(normalize(uv), vec2(spec_angle, 1.0 - spec_angle))), 6.0) * gloss;

    vec3 col = refracted + vec3(edge) + vec3(spec);
    col = clamp(col, 0.0, 1.5);

    // Use mask to discard transparent areas instead of early return
    COLOR = vec4(col, mask);
}