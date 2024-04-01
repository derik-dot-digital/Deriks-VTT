#region Draw Grid

//Grid Matrix
var grid_mat = matrix_build(grid_pos.x, grid_pos.y, grid_pos.z, 0, 0, 0, 1, 1, 1);

//Set Matrix
matrix_set(matrix_world, grid_mat);

//Overlay Mode
if overlay_mode {gpu_set_colorwriteenable(true,true,true,false);}

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

//Overlay Mode
if overlay_mode {gpu_set_colorwriteenable(true,true,true,true);}

//Reset Matrix
matrix_set(matrix_world, matrix_build_identity());

#endregion