shader_type canvas_item;

uniform vec4 hair_color : source_color = vec4(1.0, 0.6, 0.2, 1.0); // 可调整发色 (默认橙金色)
uniform float brightness = 1.0; // 总体亮度
uniform float contrast = 1.0;   // 对比度

void fragment() {
    // 取原图颜色
    vec4 base = texture(TEXTURE, UV);
    // 灰度图取 R 通道即可
    float gray = base.r;

    // 调整亮度与对比度
    gray = (gray - 0.5) * contrast + 0.5;
    gray *= brightness;

    // 将灰度映射到 hair_color 上
    vec3 colored = hair_color.rgb * gray;

    COLOR = vec4(colored, base.a * hair_color.a);
}