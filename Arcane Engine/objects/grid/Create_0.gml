#region Initialize

//Sizes
tile_size = 50;
grid_size = 100;

//Grid Color Mode
enum grid_color_mode {
	solid,
	rainbow_solid,
	rainbow_wave	
}
color_mode = grid_color_mode.solid;

//Color
grid_color = new vec4(1.0, 1.0, 1.0, 1.0);
rainbow_color_spd = 0;
rainbow_color_frame = 0;
rainbow_color_scale = 0.001;

//Store Grid Buffer
vbuff_grid = undefined;

//Grid Position
grid_pos = new vec3(0.0, 0.0, 0.0);

//Dashed Line Settings
dashed = false;
dash_scale = 0.5;
dash_offset = 0;
dash_spacing = 0.5;

//Settings Array Uniform
uni_array = shader_get_uniform(shd_grid, "uniform_array");

#endregion
#region Grid Builder

//Grid Vertex Format
vertex_format_begin();
vertex_format_add_position_3d();
vgrid_format = vertex_format_end();

//Function for building Grid vBuffer
function vbuff_create_grid(grid_size, tile_size) {
	
	//Create New vBuffer
	var vb = vertex_create_buffer();
	
	//Line Length
	var line_len  = (grid_size * tile_size);
	
	//Start Position (Centers Grid on X: 0 & Y: 0
	var sx = -line_len / 2;
	var sy = -line_len / 2;
	
	//Begin Adding Vertices to vBuffer
	vertex_begin(vb, vgrid_format);
	
	//Collumns
	for (var i = 0; i <= grid_size; i++) {

	//Point Position
    var x1 = sx + (i * tile_size);
	var x2 = x1;
    var y1 = sy;
	var y2 = y1 + line_len;
	
	//Add Points
    vertex_position_3d(vb, x1, y1, 0);
    vertex_position_3d(vb, x2, y2, 0);

	}
	
	//Rows
	for (var j = 0; j <= grid_size; j++) {

	//Point Position
    var x1 = sx;
	var x2 = x1  + line_len;
    var y1 = sy + (j * tile_size);
	var y2 = y1
	
	//Add Points
    vertex_position_3d(vb, x1, y1, 0);
    vertex_position_3d(vb, x2, y2, 0);
	
	}
	
	//Complete & Freeze vBuffer
	vertex_end(vb);
	vertex_freeze(vb);
	
	//Return Result
	return vb;
	
}

//Function for replacing vbuff with new grid
function update_grid() {
vertex_delete_buffer(vbuff_grid);
vbuff_grid = vbuff_create_grid(grid_size, tile_size);	
}

//Create Default Grid
vbuff_grid = vbuff_create_grid(grid_size, tile_size);

#endregion