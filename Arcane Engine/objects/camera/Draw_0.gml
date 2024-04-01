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
	
//Apply Matrices to Camera
camera_set_view_mat(cam, mat_view);
camera_set_proj_mat(cam, mat_projection);

//Apply Camera
camera_apply(cam);

//Clear Surface for new frame
draw_clear_alpha(0, 1);
draw_clear(0)

#endregion
#region Draw Pass

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
with(asset) {event_perform(ev_draw, 0);}

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

#endregion