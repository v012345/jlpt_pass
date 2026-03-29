shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 10.0) = 3.0;
uniform float dim : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	vec2 ps = SCREEN_PIXEL_SIZE;

	// Horizontal pass
	vec4 col = vec4(0.0);
	col += textureLod(screen_texture, SCREEN_UV + vec2(-4.0, 0.0) * ps * blur_amount, 0.0) * 0.0162;
	col += textureLod(screen_texture, SCREEN_UV + vec2(-3.0, 0.0) * ps * blur_amount, 0.0) * 0.0540;
	col += textureLod(screen_texture, SCREEN_UV + vec2(-2.0, 0.0) * ps * blur_amount, 0.0) * 0.1218;
	col += textureLod(screen_texture, SCREEN_UV + vec2(-1.0, 0.0) * ps * blur_amount, 0.0) * 0.1944;
	col += textureLod(screen_texture, SCREEN_UV, 0.0) * 0.2270;
	col += textureLod(screen_texture, SCREEN_UV + vec2(1.0, 0.0) * ps * blur_amount, 0.0) * 0.1944;
	col += textureLod(screen_texture, SCREEN_UV + vec2(2.0, 0.0) * ps * blur_amount, 0.0) * 0.1218;
	col += textureLod(screen_texture, SCREEN_UV + vec2(3.0, 0.0) * ps * blur_amount, 0.0) * 0.0540;
	col += textureLod(screen_texture, SCREEN_UV + vec2(4.0, 0.0) * ps * blur_amount, 0.0) * 0.0162;

	// Vertical pass
	vec4 col2 = vec4(0.0);
	col2 += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -4.0) * ps * blur_amount, 0.0) * 0.0162;
	col2 += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -3.0) * ps * blur_amount, 0.0) * 0.0540;
	col2 += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -2.0) * ps * blur_amount, 0.0) * 0.1218;
	col2 += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -1.0) * ps * blur_amount, 0.0) * 0.1944;
	col2 += textureLod(screen_texture, SCREEN_UV, 0.0) * 0.2270;
	col2 += textureLod(screen_texture, SCREEN_UV + vec2(0.0, 1.0) * ps * blur_amount, 0.0) * 0.1944;
	col2 += textureLod(screen_texture, SCREEN_UV + vec2(0.0, 2.0) * ps * blur_amount, 0.0) * 0.1218;
	col2 += textureLod(screen_texture, SCREEN_UV + vec2(0.0, 3.0) * ps * blur_amount, 0.0) * 0.0540;
	col2 += textureLod(screen_texture, SCREEN_UV + vec2(0.0, 4.0) * ps * blur_amount, 0.0) * 0.0162;

	COLOR.rgb = ((col + col2) / 2.0).rgb * (1.0 - dim);
	COLOR.a = 1.0;
}
