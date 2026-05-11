//shader_type canvas_item;
//
//// Beam appearance
//uniform vec4 beam_color : source_color = vec4(1.0, 0.95, 0.6, 1.0); // warm white/yellow light
//uniform float core_width : hint_range(0.0, 1.0) = 0.15;   // bright core size
//uniform float glow_falloff : hint_range(0.5, 8.0) = 3.0;  // how fast glow fades
//uniform float core_intensity : hint_range(1.0, 5.0) = 2.5; // core brightness boost
//uniform float glow_intensity : hint_range(0.1, 2.0) = 0.8; // outer glow strength
//
//// Flicker / pulse
//uniform float flicker_speed : hint_range(0.0, 20.0) = 6.0;
//uniform float flicker_amount : hint_range(0.0, 0.5) = 0.08; // 0 = no flicker
//
//void fragment() {
    //// UV.y goes 0→1 across the width of the line.
    //// Remap so 0.5 = center, and d = distance from center (0=center, 0.5=edge)
    //float d = abs(UV.y - 0.5);
//
    //// Soft flicker based on time + position along beam
    //float flicker = 1.0 - flicker_amount * (
        //sin(TIME * flicker_speed + UV.x * 8.0) * 0.5 +
        //sin(TIME * flicker_speed * 1.37 + UV.x * 3.0) * 0.5
    //);
//
    //// Core: sharp bright center
    //float core = smoothstep(core_width, 0.0, d) * core_intensity;
//
    //// Glow: wide soft falloff
    //float glow = pow(max(0.0, 1.0 - (d * 2.0)), glow_falloff) * glow_intensity;
//
    //float brightness = (core + glow) * flicker;
//
    //// Fade out at the tips (along beam length)
    //float tip_fade = smoothstep(0.0, 0.04, UV.x) * smoothstep(1.0, 0.96, UV.x);
    //brightness *= tip_fade;
//
    //vec3 color = beam_color.rgb * brightness;
//
    //// HDR-style: let the core blow out to white
    //color = mix(color, vec3(1.0), smoothstep(1.5, 3.0, brightness) * 0.6);
//
    //COLOR = vec4(color, clamp(brightness, 0.0, 1.0));
//}

shader_type canvas_item;

// Beam appearance
uniform vec4 beam_color : source_color = vec4(1.0, 0.95, 0.6, 1.0);
uniform float core_width : hint_range(0.0, 1.0) = 0.15;
uniform float glow_falloff : hint_range(0.5, 8.0) = 3.0;
uniform float core_intensity : hint_range(1.0, 5.0) = 2.5;
uniform float glow_intensity : hint_range(0.1, 2.0) = 0.8;

// Flicker / pulse
uniform float flicker_speed : hint_range(0.0, 20.0) = 6.0;
uniform float flicker_amount : hint_range(0.0, 0.5) = 0.08;

// Chromatic aberration
uniform float ca_strength : hint_range(0.0, 0.15) = 0.04; // channel split amount
uniform float ca_falloff : hint_range(0.0, 1.0) = 0.6;    // how far from center CA kicks in

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

    // Chromatic aberration: shift red outward, blue inward along beam width
    // The shift grows stronger away from the center (edge fringing)
    float center = 0.5;
    float edge_factor = pow(abs(UV.y - center) / 0.5, ca_falloff); // 0 at center, 1 at edge
    float shift = ca_strength * edge_factor;

    float d_r = abs((UV.y + shift) - center);
    float d_g = abs(UV.y - center);
    float d_b = abs((UV.y - shift) - center);

    float r = beam_brightness(d_r, flicker) * tip_fade;
    float g = beam_brightness(d_g, flicker) * tip_fade;
    float b = beam_brightness(d_b, flicker) * tip_fade;

    // Tint each channel by beam_color
    r *= beam_color.r;
    g *= beam_color.g;
    b *= beam_color.b;

    // HDR blow-out to white at the core
    float lum = (r + g + b) / 3.0;
    float blowout = smoothstep(1.5, 3.0, lum) * 0.6;
    r = mix(r, 1.0, blowout);
    g = mix(g, 1.0, blowout);
    b = mix(b, 1.0, blowout);

    float alpha = clamp((r + g + b) / 3.0, 0.0, 1.0);
    COLOR = vec4(r, g, b, alpha);
}