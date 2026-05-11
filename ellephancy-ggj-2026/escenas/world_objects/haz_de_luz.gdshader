shader_type canvas_item;
render_mode unshaded;

uniform vec4 beam_color : source_color = vec4(1.0, 0.95, 0.6, 1.0);
uniform float core_width : hint_range(0.0, 1.0) = 0.15;
uniform float glow_falloff : hint_range(0.5, 8.0) = 3.0;
uniform float core_intensity : hint_range(1.0, 5.0) = 2.5;
uniform float glow_intensity : hint_range(0.1, 2.0) = 0.8;

uniform float flicker_speed : hint_range(0.0, 20.0) = 6.0;
uniform float flicker_amount : hint_range(0.0, 0.5) = 0.08;

uniform float ca_strength : hint_range(0.0, 0.15) = 0.04;
uniform float ca_falloff : hint_range(0.0, 1.0) = 0.6;

uniform float opacity : hint_range(0.0, 1.0) = 1.0;

// Distance fade: 0 = no falloff, 1 = beam nearly dies at the end
uniform float distance_fade : hint_range(0.0, 1.0) = 0.0;

float beam_brightness(float d, float flicker) {
    float core = smoothstep(core_width, 0.0, d) * core_intensity;
    float glow = pow(max(0.0, 1.0 - (d * 2.0)), glow_falloff) * glow_intensity;
    return (core + glow) * flicker;
}

void fragment() {
    float flicker = 1.0 - flicker_amount * (
        sin(TIME * flicker_speed + UV.x * 8.0) * 0.5 +
        sin(TIME * flicker_speed * 1.37 + UV.x * 3.0) * 0.5
    );

    float tip_fade = smoothstep(0.0, 0.04, UV.x) * smoothstep(1.0, 0.96, UV.x);

    // Distance falloff: brightness decays along the beam length (UV.x = 0 at start, 1 at end)
    // pow() makes the curve adjustable — low distance_fade = gentle, high = steep drop
    float dist_falloff = 1.0 - (UV.x * distance_fade);
    dist_falloff = max(0.0, dist_falloff);

    float center = 0.5;
    float edge_factor = pow(abs(UV.y - center) / 0.5, ca_falloff);
    float shift = ca_strength * edge_factor;

    float d_r = abs((UV.y + shift) - center);
    float d_g = abs(UV.y - center);
    float d_b = abs((UV.y - shift) - center);

    float r = beam_brightness(d_r, flicker) * tip_fade * beam_color.r * dist_falloff;
    float g = beam_brightness(d_g, flicker) * tip_fade * beam_color.g * dist_falloff;
    float b = beam_brightness(d_b, flicker) * tip_fade * beam_color.b * dist_falloff;

    float lum = (r + g + b) / 3.0;
    float blowout = smoothstep(1.5, 3.0, lum) * 0.6;
    r = mix(r, 1.0, blowout);
    g = mix(g, 1.0, blowout);
    b = mix(b, 1.0, blowout);

    float alpha = clamp((r + g + b) / 3.0, 0.0, 1.0) * opacity;
    COLOR = vec4(r, g, b, alpha);
}