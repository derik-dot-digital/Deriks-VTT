attribute vec3 in_Position;                 // (x,y,z)
attribute vec3 in_Normal;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;      // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying float selected;
varying vec2 outline_size;
uniform float object_data[13];
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
	vec3 object_pos = vec3(object_data[0], object_data[1], object_data[2]);
	vec4 object_quat = vec4(object_data[3], object_data[4], object_data[5], object_data[6]);
	vec3 object_scale = vec3(object_data[7], object_data[8], object_data[9]);
	vec3 object_space_pos = transform_vertex(in_Position, object_pos, object_quat, object_scale);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(object_space_pos, 1.0);
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
	v_vNormal = in_Normal;
	outline_size = vec2(object_data[10], object_data[11]);
	selected = object_data[12];
}