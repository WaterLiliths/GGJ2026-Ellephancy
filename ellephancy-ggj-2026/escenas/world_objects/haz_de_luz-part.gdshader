shader_type canvas_item;

// Match these to your beam
uniform vec4 core_color : source_color = vec4(1.0, 0.95, 0.6, 1.0);
uniform vec4 fringe_color : source_color = vec4(0.3, 0.6, 1.0, 1.0); // CA blue fringe
uniform float ca_amount : hint_range(0.0, 1.0) = 0.5; // blend toward fringe over lifetime

void fragment() {
    // UV is 0→1 across the quad; center it
    vec2 uv = UV - 0.5;
    float dist = length(uv);

    // Soft circular particle — sharp bright core, soft falloff
    float core = smoothstep(0.18, 0.0, dist);
    float glow = smoothstep(0.5, 0.0, dist) * 0.5;
    float brightness = core * 3.0 + glow;

    // COLOR.a carries the particle's lifetime alpha (from GPUParticles2D)
    float lifetime = COLOR.a; // 1.0 = just spawned, 0.0 = about to die

    // Particles shift from beam core color → CA fringe color as they age
    // This makes them look like they were torn off the beam's edge
    float age = 1.0 - lifetime;
    vec3 tint = mix(core_color.rgb, fringe_color.rgb, age * ca_amount);

    // Chromatic aberration on the particle itself: slight RGB offset radially
    float ca = 0.06 * age; // grows stronger as particle ages
    float r = smoothstep(0.5, 0.0, length(uv + vec2(ca, 0.0)));
    float g2 = smoothstep(0.5, 0.0, dist);
    float b = smoothstep(0.5, 0.0, length(uv - vec2(ca, 0.0)));

    vec3 col = tint * brightness;
    col.r = mix(col.r, r * core_color.r, age * 0.5);
    col.b = mix(col.b, b * fringe_color.b, age * 0.5);

    // HDR core blowout
    float lum = (col.r + col.g + col.b) / 3.0;
    col = mix(col, vec3(1.0), smoothstep(1.2, 2.5, lum) * 0.7);

    float alpha = clamp(brightness, 0.0, 1.0) * lifetime;
    COLOR = vec4(col, alpha);
}