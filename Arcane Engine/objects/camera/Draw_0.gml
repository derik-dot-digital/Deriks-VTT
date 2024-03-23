#region Camera

//Check Window Size
var ww = win_w;
var wh = win_h;

//Build Matrices
var mat_view = matrix_build_lookat(pos.x, pos.y, pos.z, target.x, target.y, target.z, up_vec.x, up_vec.y, up_vec.z);
var mat_proj = matrix_build_projection_perspective_fov(-fov, ww/wh, znear, zfar);

//Ensure correct surface size
if surface_get_width(application_surface) != ww or surface_get_height(application_surface) != wh {
	surface_resize(application_surface, ww, wh);
	}
	
//Apply Matrices to Camera
camera_set_view_mat(cam, mat_view);
camera_set_proj_mat(cam, mat_proj);

//Apply Camera
camera_apply(cam);

//Clear Surface for new frame
draw_clear_alpha(0, 0);

#endregion
#region Draw Pass

with(grid) {event_perform(ev_draw, 0);}

#endregion