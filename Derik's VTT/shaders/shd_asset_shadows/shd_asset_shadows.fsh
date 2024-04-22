varying vec2 v_vTexcoord;
varying vec4 v_vColour;
void main()
{
	vec4 base_color = vec4(0.0, 0.0, 0.0, 0.75);
	float dist_from_center = distance(v_vTexcoord, vec2(0.5, 0.5));
	base_color = mix(base_color, vec4(0.0, 0.0, 0.0, 0.0), pow(dist_from_center+0.5, 7.0));
    gl_FragColor = base_color;
}
