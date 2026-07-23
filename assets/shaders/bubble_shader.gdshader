shader_type canvas_item;

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
	color *= mix(vec3(1.0), bubble_color.rgb, tint_strength);


	//Sphere lighting
	vec3 normal = normalize(vec3(uv, sqrt(max(0.001, 1.0 - r2))));
	float fresnel = pow(1.0 - normal.z, 3.0);

	vec3 light = normalize(vec3(light_direction, 1.5));

	float diffuse = max(dot(normal, light), 0.0);

	//Cel shading
	diffuse = floor(diffuse * 3.0) / 3.0;

	//Painted highlight
	vec2 highlight_uv = uv + vec2(0.25, 0.25);

	float highlight = smoothstep(
		0.35,
		0.0,
		length(highlight_uv)
	);

	highlight *= 0.8;


	//Rim
	float angle = atan(uv.y, uv.x);

	float edge =
		dist +
		sin(angle * 9.0 + TIME * 0.5) * 0.01;

	float rim =
		smoothstep(0.84, 0.92, edge) -
		smoothstep(0.92, 0.985, edge);

	//Ink outline
	float outline =
		smoothstep(0.95, 0.99, edge);


	//Lighting
	color += bubble_color.rgb * diffuse * 0.12;

	//Highlight
	color += vec3(highlight);

	//Rim
	color = mix(color, rim_color.rgb, rim * 0.8);

	//Outline
	color = mix(color, vec3(0.12, 0.18, 0.30), outline);

	//Posterize
	color = floor(color * 6.0) / 6.0;


	//Alpha
	float alpha = bubble_color.a;
	alpha += fresnel * 0.25;
	alpha += highlight * 0.4;
	alpha += rim * 0.25;

	COLOR = vec4(color, clamp(alpha, 0.0, 1.0));
}