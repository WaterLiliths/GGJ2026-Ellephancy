shader_type canvas_item;

uniform vec4 beam_color : source_color = vec4(1.0, 0.95, 0.6, 1.0);
uniform vec4 fringe_color : source_color = vec4(0.3, 0.6, 1.0, 1.0);
uniform float glow_radius : hint_range(0.1, 1.0) = 0.5;
uniform float glow_falloff : hint_range(0.5, 8.0) = 2.5;
uniform float ca_strength : hint_range(0.0, 0.2) = 0.05;
uniform float flicker_speed : hint_range(0.0, 20.0) = 5.0;
uniform float flicker_amount : hint_range(0.0, 0.3) = 0.06;
uniform float intensity : hint_range(0.0, 3.0) = 1.2;

void fragment() {
    vec2 uv = UV - 0.5;
    float dist = length(uv);
    vec2 dir = dist > 0.001 ? normalize(uv) : vec2(0.0);

    // Subtle flicker
    float flicker = 1.0 - flicker_amount * (
        sin(TIME * flicker_speed) * 0.5 +
        sin(TIME * flicker_speed * 1.73) * 0.5
    );

    // Radial CA — channels split outward from center
    float ca = ca_strength * smoothstep(0.0, glow_radius, dist);
    float r = pow(max(0.0, 1.0 - length(uv + dir * ca) / glow_radius), glow_falloff);
    float g = pow(max(0.0, 1.0 - dist / glow_radius), glow_falloff);
    float b = pow(max(0.0, 1.0 - length(uv - dir * ca) / glow_radius), glow_falloff);

    // Tint: center stays beam_color, edges bleed into fringe_color
    float edge_blend = smoothstep(0.0, glow_radius, dist);
    vec3 tint = mix(beam_color.rgb, fringe_color.rgb, edge_blend * 0.4);

    vec3 col = vec3(r, g, b) * tint * flicker * intensity;

    // Soft core blowout to white
    float lum = (col.r + col.g + col.b) / 3.0;
    col = mix(col, vec3(1.0), smoothstep(1.2, 2.5, lum) * 0.5);

    float alpha = clamp(lum, 0.0, 1.0);
    COLOR = vec4(col, alpha);
}