attribute vec3 in_Position;                  // (x,y,z)
varying vec3 pos;
void main()
{
	//Add Position Adjustment
	//Add Wave/Distortion
	//Either add Vertex texture fetching, or regenerate the grid based on a heightmap.
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	pos = object_space_pos.xyz;
}
