//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;

void main()
{
	vec4 pixel = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	if (pixel.a == 0.0) {discard;}
    gl_FragColor = pixel;
}