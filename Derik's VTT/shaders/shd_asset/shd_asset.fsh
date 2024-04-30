precision highp float;
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying float selected;
uniform float frag_is_character;
void main()
{
	vec2 uvs = vec2(1.0-v_vTexcoord.x, v_vTexcoord.y);
	vec2 outline_size = vec2(0.001, 0.001);
	vec4 outline_color = vec4(1.0, 1.0, 1.0, 1.0);
	vec4  spriteSample = texture2D(gm_BaseTexture, uvs);
    float spriteAlphaL = texture2D(gm_BaseTexture, uvs + vec2(outline_size.x, 0.0)).a;
    float spriteAlphaT = texture2D(gm_BaseTexture, uvs + vec2(0.0, outline_size.y)).a;
    float spriteAlphaR = texture2D(gm_BaseTexture, uvs - vec2(outline_size.x, 0.0)).a;
    float spriteAlphaB = texture2D(gm_BaseTexture, uvs - vec2(0.0, outline_size.y)).a;
		if (frag_is_character == 1.0) {
			float outline_size_average = (outline_size.x + outline_size.y) * 10.0;
			float dist_from_center = distance(v_vTexcoord, vec2(0.5, 0.5));
			float character_rad = 0.5 - outline_size_average;
			spriteSample.rgb = mix(spriteSample.rgb, vec3(0.0, 0.0, 0.0), pow(dist_from_center+0.5, 10.0));
			if (dist_from_center > character_rad) {
				spriteSample.a = 0.0;
				if (dist_from_center < (character_rad + outline_size_average)) {
					spriteAlphaL = 1.0;
				} 
				else
				{
					spriteAlphaL = 0.0;
					spriteAlphaT = 0.0;
					spriteAlphaR = 0.0;
					spriteAlphaB = 0.0;
				}
			}
		}
		
	//Selected 
	if (selected == 1.0) {
		
		float outline_applied = 0.0;
		
		//Regular Outline
		float alpha_threshold = 0.5;
		if (spriteSample.a <= alpha_threshold)
	    {
	        if ((spriteAlphaL >= alpha_threshold)
	        ||  (spriteAlphaT >= alpha_threshold)
	        ||  (spriteAlphaR >= alpha_threshold)
	        ||  (spriteAlphaB >= alpha_threshold))
	        {
				gl_FragColor = outline_color;
				outline_applied = 1.0;
	        }
	    }
	
		//Edge Outline
		if (frag_is_character == 0.0) {
			if ((v_vTexcoord.x < outline_size) 
			|| (v_vTexcoord.x > 1.0 - outline_size)
			|| (v_vTexcoord.y < outline_size) 
			|| (v_vTexcoord.y > 1.0 - outline_size))
			{
				gl_FragColor = outline_color;
				outline_applied = 1.0;
			}
		}
		
		if (outline_applied == 0.0) {
			gl_FragColor = v_vColour * spriteSample;
			if (spriteSample.a == 0.0) {discard;}
		}
	}
	else
	{
		if (spriteSample.a == 0.0) {discard;}
	    gl_FragColor = v_vColour * spriteSample;
	}
}