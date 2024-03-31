#region Camera

//Check Window Size
var ww = win_w;
var wh = win_h;

//Build Matrices
var vm = view_quat.Normalize().AsMatrix(pos);
var pm = array_lerp_exp(mat_proj_perspective, mat_proj_orthographic, projection_slider, 5);

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
camera_set_view_mat(cam, vm);
camera_set_proj_mat(cam, pm);

//Apply Camera
camera_apply(cam);

//Clear Surface for new frame
draw_clear_alpha(0, 0);

#endregion
#region Draw Pass

//Grid
with(grid) {event_perform(ev_draw, 0);}

//Assets
gpu_set_depth(10);
with(asset) {event_perform(ev_draw, 0);}
gpu_set_depth(0);

#endregion