shader_type canvas_item;

uniform vec2 wave_origin;
uniform float wave_radius = 0.0;

uniform vec2 rune_world_position;

uniform float feather = 150.0;

void fragment()
{
    float dist =
        distance(rune_world_position,
                 wave_origin);

    float reveal =
        smoothstep(
            wave_radius - feather,
            wave_radius,
            dist
        );

    vec4 tex =
        texture(TEXTURE, UV);

    COLOR.rgb = tex.rgb;

    COLOR.a = 1.0 - reveal;
}