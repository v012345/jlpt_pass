shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;
uniform float lod : hint_range(0.0, 5.0) = 1.5;
uniform float dim : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	vec2 ps = SCREEN_PIXEL_SIZE * blur_amount;

	// 13-tap horizontal gaussian
	vec4 h = vec4(0.0);
	h += textureLod(screen_texture, SCREEN_UV + vec2(-6.0, 0.0) * ps, lod) * 0.002216;
	h += textureLod(screen_texture, SCREEN_UV + vec2(-5.0, 0.0) * ps, lod) * 0.008764;
	h += textureLod(screen_texture, SCREEN_UV + vec2(-4.0, 0.0) * ps, lod) * 0.026995;
	h += textureLod(screen_texture, SCREEN_UV + vec2(-3.0, 0.0) * ps, lod) * 0.064759;
	h += textureLod(screen_texture, SCREEN_UV + vec2(-2.0, 0.0) * ps, lod) * 0.120985;
	h += textureLod(screen_texture, SCREEN_UV + vec2(-1.0, 0.0) * ps, lod) * 0.176033;
	h += textureLod(screen_texture, SCREEN_UV, lod) * 0.199471;
	h += textureLod(screen_texture, SCREEN_UV + vec2(1.0, 0.0) * ps, lod) * 0.176033;
	h += textureLod(screen_texture, SCREEN_UV + vec2(2.0, 0.0) * ps, lod) * 0.120985;
	h += textureLod(screen_texture, SCREEN_UV + vec2(3.0, 0.0) * ps, lod) * 0.064759;
	h += textureLod(screen_texture, SCREEN_UV + vec2(4.0, 0.0) * ps, lod) * 0.026995;
	h += textureLod(screen_texture, SCREEN_UV + vec2(5.0, 0.0) * ps, lod) * 0.008764;
	h += textureLod(screen_texture, SCREEN_UV + vec2(6.0, 0.0) * ps, lod) * 0.002216;

	// 13-tap vertical gaussian
	vec4 v = vec4(0.0);
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -6.0) * ps, lod) * 0.002216;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -5.0) * ps, lod) * 0.008764;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -4.0) * ps, lod) * 0.026995;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -3.0) * ps, lod) * 0.064759;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -2.0) * ps, lod) * 0.120985;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -1.0) * ps, lod) * 0.176033;
	v += textureLod(screen_texture, SCREEN_UV, lod) * 0.199471;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, 1.0) * ps, lod) * 0.176033;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, 2.0) * ps, lod) * 0.120985;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, 3.0) * ps, lod) * 0.064759;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, 4.0) * ps, lod) * 0.026995;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, 5.0) * ps, lod) * 0.008764;
	v += textureLod(screen_texture, SCREEN_UV + vec2(0.0, 6.0) * ps, lod) * 0.002216;

	COLOR.rgb = ((h + v) / 2.0).rgb * (1.0 - dim);
	COLOR.a = 1.0;
}
