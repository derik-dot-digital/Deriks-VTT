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