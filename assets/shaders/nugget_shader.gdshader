shader_type canvas_item;

uniform vec4 color_dark : source_color = vec4(0.5, 0.0, 0.2, 1.0);
uniform vec4 color_mid  : source_color = vec4(0.8, 0.0, 0.2, 1.0);
uniform vec4 color_light: source_color = vec4(1.0, 0.3, 0.43, 1.0);

uniform float shine_speed = 2.0;
uniform float shine_width = 1.0;
uniform float shine_strength = 0.6;
uniform float noise_amount = 0.08;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

void fragment() {

    vec4 tex = texture(TEXTURE, UV);

    //Keep sprite transparency
    if (tex.a < 0.01) {
        discard;
    }

    //Vertical gradient
    vec3 render_color = mix(color_dark.rgb, color_mid.rgb, UV.y);
    render_color = mix(render_color, color_light.rgb, pow(UV.y, 3.0));

    //Moving metallic shine
    float shine =
        smoothstep(
            shine_width,
            0.0,
            abs(UV.x - fract(TIME * shine_speed))
        );

    render_color += shine * shine_strength;

    //Small random sparkle
    float sparkle = hash(floor(UV * 32.0));
    sparkle *= noise_amount;

    render_color += sparkle;

    //Slight darkening toward edges
    vec2 c = UV * 2.0 - 1.0;
    float edge = length(c);
    render_color *= 1.0 - edge * 0.2;

    COLOR = vec4(render_color, tex.a);
}