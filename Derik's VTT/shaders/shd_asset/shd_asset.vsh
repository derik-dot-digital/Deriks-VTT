attribute vec3 in_Position;                 // (x,y,z)
attribute vec3 in_Normal;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;      // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying float selected;
varying vec2 outline_size;
uniform float object_data[14];

vec3 rotate_quaternion(vec3 vec, vec4 q)
{
	return vec + 2.0*cross(cross(vec, q.xyz ) + q.w*vec, q.xyz);
}

vec3 transform_vertex(vec3 vec, vec3 pos, vec4 rot, vec3 scale)
{
	vec3 vertex = rotate_quaternion(vec * scale, rot);
	return vertex + pos;
}

void main()
{
	float is_character = object_data[13];
	vec3 object_pos = vec3(object_data[0], object_data[1], object_data[2]);
	vec4 object_quat = vec4(object_data[3], object_data[4], object_data[5], object_data[6]);
	vec3 object_scale = vec3(object_data[7], object_data[8], object_data[9]);
	vec3 object_space_pos = transform_vertex(in_Position, object_pos, object_quat, object_scale);
	if (is_character > 0.0) {
		mat4 worldview = gm_Matrices[MATRIX_WORLD_VIEW];
	
		worldview[0][0] = 1.0;
		worldview[0][1] = 0.0;
		worldview[0][2] = 0.0;
	
		worldview[1][0] = 0.0;
		worldview[1][1] = 1.0;
		worldview[1][2] = 0.0;
	
		worldview[2][0] = 0.0;
		worldview[2][1] = 0.0;
		worldview[2][2] = 1.0;	

		vec3 billboard_scale = object_scale * 2.0;
		billboard_scale.y *= -1.0;
		vec3 object_space_pos = (in_Position * billboard_scale);
		vec4 object_space_posi = gm_Matrices[MATRIX_PROJECTION] * (worldview * vec4(object_space_pos, 1.0));
		gl_Position = object_space_posi + (gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(object_pos * 2.0, 1.0));	
    	}
		else 
		{
		gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(object_space_pos, 1.0);	
		}
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
	v_vNormal = in_Normal;
	outline_size = vec2(object_data[10], object_data[11]);
	selected = object_data[12];
}