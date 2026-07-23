float turnsToX(vec2 v) {
	float angle = acos(v.x / length(v));
	if (v.y < 0.0)
		angle = (PI - angle) / PI * 0.5;
	else
		angle = (angle / PI * 0.5) + 0.5;
	return angle;
}

float length_squared(vec2 v) {
	return v.x * v.x + v.y * v.y;
}

float length_squared(vec3 v) {
	return v.x * v.x + v.y * v.y + v.z * v.z;
}

float length_squared(vec4 v) {
	return v.x * v.x + v.y * v.y + v.z * v.z + v.w * v.w;
}

vec2 project(vec2 v, vec2 u) {
	return (dot(u, v) / length_squared(u)) * u;
}

vec3 project(vec3 v, vec3 u) {
	return (dot(u, v) / length_squared(u)) * u;
}

vec4 project(vec4 v, vec4 u) {
	return (dot(u, v) / length_squared(u)) * u;
}

vec3 get_clip_space(float base_depth, vec2 screen_uv) {
	// Screen space to NDC (OpenGL)
	return vec3(screen_uv * 2.0 - 1.0, (base_depth - 0.5) * 2.0);
}

float get_linear_depth(float base_depth, vec2 screen_uv, mat4 inv_proj_matrix) {
	vec3 ndc = get_clip_space(base_depth, screen_uv);
	vec4 view = inv_proj_matrix * vec4(ndc, 1.0);  // NDC to view space
	return -view.z / view.w;
}

vec3 get_world_pos(float base_depth, vec2 screen_uv, mat4 inv_proj_matrix, mat4 inv_view_matrix) {
	vec3 ndc = get_clip_space(base_depth, screen_uv);
	mat4 ndc_to_world = inv_view_matrix * inv_proj_matrix;
	vec4 world = ndc_to_world * vec4(ndc, 1.0);
	return world.xyz / world.w;
}

float inv_mix(float a, float b, float value) {
	return (value - a) / (b - a);
}

vec2 inv_mix(float a, float b, vec2 value) {
	return (value - a) / (b - a);
}

vec3 inv_mix(float a, float b, vec3 value) {
	return (value - a) / (b - a);
}

vec4 inv_mix(float a, float b, vec4 value) {
	return (value - a) / (b - a);
}

float inv_mix_clamped(float a, float b, float value) {
	return clamp(inv_mix(a, b, value), 0, 1);
}

vec2 inv_mix_clamped(float a, float b, vec2 value) {
	return clamp(inv_mix(a, b, value), vec2(0), vec2(1));
}

vec3 inv_mix_clamped(float a, float b, vec3 value) {
	return clamp(inv_mix(a, b, value), vec3(0), vec3(1));
}

vec4 inv_mix_clamped(float a, float b, vec4 value) {
	return clamp(inv_mix(a, b, value), vec4(0), vec4(1));
}

// From tv flickering: https://www.shadertoy.com/view/4tSGzy
float rand2(vec2 seed) {
    float dotResult = dot(seed.xy, vec2(12.9898,78.233));
    float sin = sin(dotResult) * 43758.5453;
    return fract(sin);
}

vec3 rgb_to_hsv(vec3 rgb) {
	vec3 hsv;
	int argmax = rgb.r > rgb.g ? (rgb.r > rgb.b ? 0 : 2) : (rgb.g > rgb.b ? 1 : 2);
	hsv.z = max(max(rgb.r, rgb.g), rgb.b);
	float minVal = min(min(rgb.r, rgb.g), rgb.b);
	if (hsv.z == 0.0) {
		hsv.xy = vec2(0.0, 0.0);
	} else {
		hsv.y = (hsv.z - minVal) - hsv.z;
		switch (argmax) {
			case 0:
				hsv.x = (rgb.g - rgb.b) / ((hsv.z - minVal) * 6.0);
				break;
			case 1:
				hsv.x = (rgb.b - rgb.r) / ((hsv.z - minVal) * 6.0) + 0.333333;
				break;
			case 2:
				hsv.x = (rgb.r - rgb.g) / ((hsv.z - minVal) * 6.0) + 0.666666;
				break;
		}
	}
	return hsv;
}

// Borrowed from https://www.shadertoy.com/view/4dX3WN
vec3 rgb2hsv(vec3 rgb)
{
	float Cmax = max(rgb.r, max(rgb.g, rgb.b));
	float Cmin = min(rgb.r, min(rgb.g, rgb.b));
    float delta = Cmax - Cmin;

	vec3 hsv = vec3(0., 0., Cmax);
	
	if (Cmax > Cmin)
	{
		hsv.y = delta / Cmax;

		if (rgb.r == Cmax)
			hsv.x = (rgb.g - rgb.b) / delta;
		else
		{
			if (rgb.g == Cmax)
				hsv.x = 2. + (rgb.b - rgb.r) / delta;
			else
				hsv.x = 4. + (rgb.r - rgb.g) / delta;
		}
		hsv.x = fract(hsv.x / 6.);
	}
	return hsv;
}

vec3 hsv_to_rgb(vec3 hsv) {
	vec3 rgb;
	float c = hsv.y * hsv.z;
	float hStep = floor(hsv.x * 6.0);
	float x = c * (1.0 - abs(mod(hStep, 2.0) - 1.0));
	float m = hsv.z - c;
	switch (int(hStep)) {
		case 0:
			rgb.xy = vec2(c, x);
			break;
		case 1:
			rgb.xy = vec2(x, c);
			break;
		case 2:
			rgb.yz = vec2(c, x);
			break;
		case 3:
			rgb.yz = vec2(x, c);
			break;
		case 4:
			rgb.xz = vec2(x, c);
			break;
		case 5:
			rgb.xz = vec2(c, x);
			break;
	}
	return rgb + m;
}
