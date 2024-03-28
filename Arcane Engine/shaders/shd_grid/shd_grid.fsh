varying vec3 pos;
uniform float uniform_array[11];

vec3 hsv2rgb(vec3 c) 
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}


void main()
{
	
	//Store Default Color
	vec4 color = vec4(uniform_array[0], uniform_array[1], uniform_array[2], uniform_array[3]);
	
	#region Dashed Lines
	
	//Get Settings
	float dashed = uniform_array[4];
	float dash_scale = uniform_array[5];
	float dash_offset = uniform_array[6];
	float dash_spacing = uniform_array[7];

	//Dashed 
	if (dashed > 0.0) {
		if (step(sin(dash_scale * (pos.x + dash_offset)), dash_spacing) == 0.0) {discard;}
		if (step(sin(dash_scale * (pos.y + dash_offset)), dash_spacing) == 0.0) {discard;}
		if (step(sin(dash_scale * (pos.z + dash_offset)), dash_spacing) == 0.0) {discard;}
	}
	
	#endregion
	#region Rainbow
	
	//Get Settings
	float color_mode = uniform_array[8];
	float rainbow_color_frame = uniform_array[9];
	float rainbow_color_scale = uniform_array[10];
	
	//Update Color to Rainbow
	if (color_mode > 0.0) { //0 = Solid Color
		
		//Add A Secondary Mode that switches from Radial, Directional, Etc...
		
		//Rainbow Wave
		if (color_mode > 1.0) {
		vec3 rainbow_hsv = vec3((((distance(pos, vec3(0.0, 0.0, 0.0)))/3.0)*rainbow_color_scale)+rainbow_color_frame, 1.0, 1.0);
		 color.rgb = hsv2rgb(rainbow_hsv);
		} else { // Solid Rainbow
		vec3 rainbow_hsv = vec3(rainbow_color_frame, 1.0, 1.0);
		color.rgb = hsv2rgb(rainbow_hsv);
		}
	
	}
	
	#endregion
	
	gl_FragColor = color;
}
