#region Draw Grid

//Grid Matrix
var grid_mat = matrix_build(grid_pos.x, grid_pos.y, grid_pos.z, 0, 0, 0, 1, 1, 1);

//Set Matrix
matrix_set(matrix_world, grid_mat);

//Set Grid Shader
shader_set(shd_grid);

//Submit Point List
vertex_submit(vbuff_grid, pr_linelist, -1);

//Reset Shader
shader_reset();

//Reset Matrix
matrix_set(matrix_world, matrix_build_identity());

#endregion