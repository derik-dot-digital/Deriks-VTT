
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float uniform_array[10];
varying vec3 world_normal;

//Perception Based Color Mixing
vec3 oklab_mix(vec3 lin1, vec3 lin2, float a)
{
    // https://bottosson.github.io/posts/oklab
    const mat3 kCONEtoLMS = mat3(                
         0.4121656120,  0.2118591070,  0.0883097947,
         0.5362752080,  0.6807189584,  0.2818474174,
         0.0514575653,  0.1074065790,  0.6302613616);
    const mat3 kLMStoCONE = mat3(
         4.0767245293, -1.2681437731, -0.0041119885,
        -3.3072168827,  2.6093323231, -0.7034763098,
         0.2307590544, -0.3411344290,  1.7068625689);
                    
    // rgb to cone (arg of pow can't be negative)
    vec3 lms1 = pow( kCONEtoLMS*lin1, vec3(1.0/3.0) );
    vec3 lms2 = pow( kCONEtoLMS*lin2, vec3(1.0/3.0) );
    // lerp
    vec3 lms = mix( lms1, lms2, a );
    // gain in the middle (no oklab anymore, but looks better?)
    lms *= 1.0+0.2*a*(1.0-a);
    // cone to rgb
    return kLMStoCONE*(lms*lms*lms);
}

void main()
	{
	
	//Store Color & Mode
	vec4 result = vec4(0.0, 0.0, 0.0, 1.0);
	
	#region Standard
	
	//Get Settings
	vec4 day_color = vec4(uniform_array[0], uniform_array[1], uniform_array[2], 1.0);
	vec4 night_color = vec4(uniform_array[3], uniform_array[4], uniform_array[5], 1.0);
	vec3 sun_dir = normalize(-vec3(uniform_array[6], uniform_array[7], uniform_array[8]));
	float sun_dot = dot(world_normal, sun_dir);
	float dynamic_style = uniform_array[9];
	
	//Solid
	if (dynamic_style == 0.0) {
		result = vec4(oklab_mix(night_color.rgb, day_color.rgb, dot(sun_dir, vec3(0.0, 0.0, 1.0))), 1.0);
	}
	else
	{
		//Gradient
		if (dynamic_style == 1.0) {
			result = vec4(oklab_mix(night_color.rgb, day_color.rgb, sun_dot), 1.0);
		}
	}
	
	#endregion
	
	//Render Resutlt
	gl_FragColor = result;
	
	}
