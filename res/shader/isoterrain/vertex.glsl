uniform mat4 u_projection;
uniform mat4 u_view;

uniform vec2 u_pos;
uniform vec2 u_tilesize;


attribute vec2 a_position;
attribute vec2 a_texcoord;

varying vec2 v_texcoord;

void main() {
	float row_shift = floor(u_pos.y) / 2.0;
	vec2 start_shift = vec2(0.0);
		start_shift.x = -floor(u_pos.x) / 2.0;
		start_shift.y = -floor(u_pos.x) * 1.0;

	vec2 iso_pos = (u_pos + vec2(row_shift, 0.0) + start_shift) * vec2(1.0, 0.234);

	gl_Position = u_projection * u_view * vec4(a_position + iso_pos * (u_tilesize * vec2(5.5, 5.0)), 0.0, 1.0);
	v_texcoord = a_texcoord;
}

