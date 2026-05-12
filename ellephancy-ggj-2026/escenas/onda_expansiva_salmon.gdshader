shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

uniform vec2 center = vec2(0.5);

uniform float max_radius = 1.5;

uniform float ring_width = 0.04;
uniform float feather = 0.08;

uniform vec3 glow_color =
	vec3(0.4, 0.8, 1.0);

uniform float glow_strength = 2.0;

void fragment()
{
	vec2 uv = SCREEN_UV;

	float aspect =
		SCREEN_PIXEL_SIZE.y /
		SCREEN_PIXEL_SIZE.x;

	vec2 scaled_uv =
		(uv - vec2(0.0, 0.5))
		/ vec2(1.0, aspect)
		+ vec2(0.0, 0.5);

	vec2 scaled_center =
		(center - vec2(0.0, 0.5))
		/ vec2(1.0, aspect)
		+ vec2(0.0, 0.5);

	float radius =
		progress * max_radius;

	float dist =
		distance(
			scaled_uv,
			scaled_center
		);

	float ring =
		smoothstep(
			radius - ring_width - feather,
			radius - ring_width,
			dist
		)
		*
		(
			1.0 -
			smoothstep(
				radius,
				radius + feather,
				dist
			)
		);

	vec3 color =
		glow_color *
		ring *
		glow_strength;

	COLOR.rgb = color;
	COLOR.a = ring;
}