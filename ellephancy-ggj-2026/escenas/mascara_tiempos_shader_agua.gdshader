shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

uniform vec2 center = vec2(0.5, 0.5);

uniform float max_radius = 1.5;
uniform float feather = 0.15;

uniform float ring_width = 0.06;

uniform float distortion_strength = 0.03;
uniform float aberration_strength = 0.008;

uniform vec3 glow_color = vec3(0.4, 0.8, 1.0);
uniform float glow_strength = 1.5;

void fragment()
{
    vec2 uv = UV;

    float aspect =
        SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

    vec2 scaled_uv =
        (uv - vec2(0.0, 0.5))
        / vec2(1.0, aspect)
        + vec2(0.0, 0.5);


    float radius = progress * max_radius;

    vec2 scaled_center =
    (center - vec2(0.0, 0.5))
    / vec2(1.0, aspect)
    + vec2(0.0, 0.5);

float dist =
    distance(scaled_uv, scaled_center);

    float reveal =
        smoothstep(radius - feather,
                   radius,
                   dist);


    float ring =
        smoothstep(radius - ring_width,
                   radius,
                   dist)
        -
        smoothstep(radius,
                   radius + ring_width,
                   dist);


    vec2 dir =
        normalize(scaled_uv - scaled_center);


    vec2 distorted_uv =
        uv + dir * distortion_strength * ring;


    vec4 r =
        texture(TEXTURE,
                distorted_uv +
                dir * aberration_strength * ring);

    vec4 g =
        texture(TEXTURE,
                distorted_uv);

    vec4 b =
        texture(TEXTURE,
                distorted_uv -
                dir * aberration_strength * ring);

    vec3 final_color =
        vec3(r.r, g.g, b.b);


    final_color +=
        glow_color * ring * glow_strength;


    COLOR.rgb = final_color;

    COLOR.a = reveal;
}
//cualquier cosita, el shader base viene de aca: https://godotshaders.com/shader/za-warudo-shockwave-effect/
//igual tiene licencia cc0 :D