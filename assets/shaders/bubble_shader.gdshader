shader_type canvas_item;

#include "res://addons/leeklib/shader_util.gdshaderinc"

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 bubble_color : source_color = vec4(0.35, 0.75, 1.0, 1.0);
uniform vec4 rim_color : source_color = vec4(0.95, 0.98, 1.0, 1.0);

uniform float rim_width : hint_range(0.0, 0.5) = 0.12;

uniform float wobble_strength : hint_range(0.0, 0.1) = 0.01;
uniform float wobble_speed : hint_range(1.0, 15.0) = 10.0;

uniform vec2 light_direction = vec2(1.0, -1.0);

uniform float lens_radius : hint_range(0.0, 5.0, 0.01) = 5.0;
uniform float lens_power : hint_range(0.01, 3.0, 0.01) = 0.08;
uniform float tint_strength : hint_range(0.0, 1.0) = 0.6;

varying vec2 screen_center;

void vertex() {
    screen_center = (CANVAS_MATRIX * MODEL_MATRIX[3]).xy;
}

void fragment() {

	//Bubble UV
	vec2 uv = UV * 2.0 - 1.0;

	uv += vec2(
		sin(uv.y * 10.0 + TIME * wobble_speed),
		cos(uv.x * 10.0 + TIME * wobble_speed * 0.8)
	) * wobble_strength;

	float r2 = dot(uv, uv);

	if (r2 > 1.0)
		discard;

	float dist = sqrt(r2);


	//Magnifying Glass
	vec2 screen_uv = SCREEN_UV;
	vec2 center_uv = screen_center * SCREEN_PIXEL_SIZE;

	//Prevent oval distortion
	vec2 aspect = vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
	vec2 adjusted_uv = (screen_uv - center_uv) * aspect + center_uv;
	float lens_dist = distance(center_uv, adjusted_uv);

	//Original lens warp
	float warp = clamp(
		1.0 - pow(lens_dist / lens_radius, lens_power),
		0.0,
		1.0
	);

	//Fade distortion near the bubble edge
	warp *= 1.0 - smoothstep(0.75, 1.0, dist);

	vec2 warped_uv = screen_uv + (center_uv - screen_uv) * warp;


	//Background
	vec3 color = texture(SCREEN_TEXTURE, warped_uv).rgb;

	//Tint
	//color *= mix(vec3(1.0), bubble_color.rgb, tint_strength);
	color = mix(color, vec3(1.0), 0.5);


	//Sphere lighting
	vec3 normal = normalize(vec3(uv, sqrt(max(0.001, 1.0 - r2))));
	float fresnel = pow(1.0 - normal.z, 3.0);

	vec3 light = normalize(vec3(light_direction, 1.5));

	float diffuse = max(dot(normal, light), 0.0);

	//Cel shading
	diffuse = floor(diffuse * 3.0) / 3.0;

	//Painted highlight
	float highlight_angle = turnsToX(uv);
	float highlight_dist = smoothstep(0.5, 0.65, length(uv))
	                       - smoothstep(0.65, 0.8, length(uv));
	float highlight_angled = (smoothstep(0.15, 0.35, highlight_angle)
	                         - smoothstep(0.35, 0.55, highlight_angle))
							 + (smoothstep(0.5, 0.55, highlight_angle)
	                            - smoothstep(0.55, 0.6, highlight_angle))
							 + (smoothstep(0.75, 0.9, highlight_angle)
	                            - smoothstep(0.9, 1.0, highlight_angle));

	float highlight = highlight_angled * highlight_dist;

	highlight *= 0.8;
	highlight = smoothstep(0.2, 0.35, highlight);


	//Rim
	float angle = atan(uv.y, uv.x);

	float edge =
		dist +
		sin(angle * 9.0 + TIME * 0.5) * 0.01;

	float rim =
		smoothstep(0.80, 0.92, edge) -
		smoothstep(0.92, .98, edge);

	//Ink outline
	float outline =
		smoothstep(0.95, 0.99, edge);


	//Lighting
	color += bubble_color.rgb * diffuse * 0.12;

	//Highlight
	color += vec3(highlight);

	//Rim
	color = mix(color, rim_color.rgb, rim * 2.0);

	//Outline
	color = mix(color, vec3(0.12, 0.18, 0.30), outline);

	//Posterize
	color = floor(color * 8.0) / 8.0;


	//Alpha
	float alpha = bubble_color.a;
	alpha += fresnel * 0.25;
	alpha += highlight * 0.4;
	alpha += rim * 0.25;
	alpha *= 1.0 - smoothstep(0.92, .98, edge);

	COLOR = vec4(color, clamp(alpha, 0.0, 1.0));
}