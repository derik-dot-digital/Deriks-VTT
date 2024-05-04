#region Camera

//Check Window Size
var ww = win_w;
var wh = win_h;

//Build Matrices
mat_view = view_quat.Normalize().AsViewMatrix(pos);
mat_projection = array_lerp_exp(mat_proj_perspective, mat_proj_orthographic, projection_slider, 5);

//Detect Changes in Window Size
if surface_get_width(application_surface) != ww or surface_get_height(application_surface) != wh {
	
	//Update Surface Size
	surface_resize(application_surface, ww, wh);
	
	//Update Aspect
	aspect = ww/wh;
	
}
	
//Update Camera Projections
mat_proj_perspective = matrix_build_projection_perspective_fov(-fov, aspect, znear_perspective, zfar);
mat_proj_orthographic = matrix_build_projection_ortho((-ww * 0.001) * zoom,  (-wh * 0.001) * zoom, znear_ortho, zfar);
	
//Set View Matrix
camera_set_view_mat(cam, mat_view);

//Clear Frame
draw_clear_alpha(0,0);

#endregion
#region Draw Pass

//Skybox (Has to be rendered with Perspective Camera)
camera_set_proj_mat(cam, mat_proj_perspective);
camera_apply(cam);
with (skybox) {event_perform(ev_draw, 0);}

//Apply Scene Camera
camera_set_proj_mat(cam, mat_projection);
camera_apply(cam);

//Grid
var gd = grid.depth_mode;
if gd = "Always Behind" {
	gpu_set_zwriteenable(false);	
}
if gd != "Always Above" {
with(grid) {
	event_perform(ev_draw, 0);
	}
}
if gd = "Always Behind" {
	gpu_set_zwriteenable(true);	
}

//Assets
with(asset) {
	event_perform(ev_draw, 0);
}
with (asset) {
	shader_set(shd_asset_shadows);
	event_user(1);
	shader_reset();	
}

//Teleport Indicator
if global.selection_action = asset_actions.teleport {
	var tile_hs = grid.tile_size/2;
	var teleport_vbuff_pos = teleport_pos.Add(world_up.Mul(tile_hs));
	var vbuff_pyramid_mat = vbuff_pyramid_quat.AsTransformMatrix(teleport_vbuff_pos, vbuff_teleport_scale);
	matrix_set(matrix_world, vbuff_pyramid_mat);
	vertex_submit(vbuff_teleport, pr_trianglelist, -1);
	matrix_set(matrix_world, mat_default);
}

// Walking Indicator
if global.selection_action == asset_actions.walk {
    
    // Store the tile size
    var ts = grid.tile_size / 2;

    // Store initial and target positions rounded to the nearest tile center
    var x0 = round(walk_start_pos.x);
    var y0 = round(walk_start_pos.y );
    var x1 = round(walk_target_pos.x );
    var y1 = round(walk_target_pos.y );

    // Calculate deltas and steps
    var dx = abs(x1 - x0);
    var sx = x0 < x1 ? ts : -ts;
    var dy = -abs(y1 - y0);
    var sy = y0 < y1 ? ts : -ts;
    var err = dx + dy, e2; // error value e_xy

    // Store vertex buffer and format
    var vb = vertex_create_buffer();
    vertex_begin(vb, grid.vgrid_format);
    var inst_z = global.selected_inst.pos.z; // Store Asset Z

	 // Add the first vertex position for the starting point
    vertex_position_3d(vb, x0, y0, inst_z);
	
	// Bresenham's algorithm
	walk_steps = 0;
	diagonal_steps = 0;
	var max_path = 500;
	while (true) {
	if (x0 == x1 && y0 == y1) break; // Check if the endpoint has been reached
	var start_pos = new vec2(x0, y0);
	e2 = 2 * err;
	if (e2 >= dy) { // e_xy+e_x > 0
	    if (x0 == x1) break;
	    err += dy;
	    x0 += sx;
	}
	if (e2 <= dx) { // e_xy+e_y < 0
	    if (y0 == y1) break;
	    err += dx;
	    y0 += sy;
	}
	
	//Increment steps
	walk_steps++;
	if walk_steps > max_path {break;}
	var step_angle = start_pos.AngleTo(new vec2(x0, y0));
	if (step_angle mod 45 = 0.0) and  (step_angle mod 90 != 0) and (step_angle != 0) {
		diagonal_steps++; 
		if (diagonal_steps mod 4 = 0.0) {walk_steps+= 2};
	}
	
	
	// Add vertex for current position
	vertex_position_3d(vb, x0, y0, inst_z);
	vertex_position_3d(vb, x0, y0, inst_z);
	}

    // Complete & Freeze vertex buffer
    vertex_end(vb);
    vertex_freeze(vb);

    // Draw and clean up
    vertex_submit(vb, pr_linelist, -1);
    vertex_delete_buffer(vb);
	
	var tile_hs = grid.tile_size/2;
	var teleport_vbuff_pos = walk_target_pos.Add(world_up.Mul(tile_hs));
	var vbuff_pyramid_mat = vbuff_pyramid_quat.AsTransformMatrix(teleport_vbuff_pos, vbuff_teleport_scale);
	matrix_set(matrix_world, vbuff_pyramid_mat);
	vertex_submit(vbuff_teleport, pr_trianglelist, -1);
	matrix_set(matrix_world, mat_default);
}

//Grid
if gd = "Always Above" {
	gpu_set_ztestenable(false);
	gpu_set_zwriteenable(false);
	with(grid) {
		event_perform(ev_draw, 0);
	}
	gpu_set_zwriteenable(true);	
	gpu_set_ztestenable(true);
}

if gd = "Overlay" {
	//DOESNT DO ANYTHING FOR NOW
	with(grid) {
		event_perform(ev_draw, 0);
	}
}


#endregion