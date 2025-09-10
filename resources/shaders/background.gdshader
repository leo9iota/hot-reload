shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV + vec2(.12 * TIME, .06 * TIME));
	COLOR = color;
}
