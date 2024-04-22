#region Draw Grid

//Check if Enabled
if enabled {

var cam_v = camera.dir;
var cam_is_axis_aligned = false;
var cam_aligned_axis = undefined;
if camera.projection_slider = 1 {
	if cam_v.Equals(world_x) {cam_is_axis_aligned = true; cam_aligned_axis = "x_axis";}
	if cam_v.Equals(world_y) {cam_is_axis_aligned = true; cam_aligned_axis = "y_axis";}
	if cam_v.Equals(world_x.Negate()) {cam_is_axis_aligned = true; cam_aligned_axis = "x_axis";}
	if cam_v.Equals(world_y.Negate()) {cam_is_axis_aligned = true; cam_aligned_axis = "y_axis";}
}

//Grid Rotation
var grid_xrot = 0;
var grid_yrot = 0;
if cam_is_axis_aligned {
	if cam_aligned_axis = "x_axis" {
	grid_yrot = 90;
	}
	if cam_aligned_axis = "y_axis" {
	grid_xrot = 90;	
	}
}

//Grid Matrix
var grid_mat = matrix_build(grid_pos.x, grid_pos.y, grid_pos.z, grid_xrot, grid_yrot, 0, 1, 1, 1);

//Set Matrix
matrix_set(matrix_world, grid_mat);

//Set Grid Shader
shader_set(shd_grid);

//Update Rainbow Color Anim
rainbow_color_frame += rainbow_color_spd;

//Store Uniforms in array
var settings_array = [	grid_color.x, grid_color.y, grid_color.z, grid_color.w,
											dashed, dash_scale, dash_offset, dash_spacing,
											color_mode, rainbow_color_frame, rainbow_color_scale];

//Pass in Uniforms
shader_set_uniform_f_array(uni_array, settings_array);

//Submit Point List
vertex_submit(vbuff_grid, pr_linelist, -1);

//Reset Shader
shader_reset();

//Reset Matrix
matrix_set(matrix_world, matrix_build_identity());

}

#endregion