var ww = win_w;
var wh = win_h;
var mat_view = matrix_build_lookat(pos.x, pos.y, pos.z, target.x, target.y, target.z, 0, 0, 1);
var mat_proj = matrix_build_projection_perspective_fov(-fov, ww/wh, znear, zfar);
camera_set_view_mat(cam, mat_view);
camera_set_proj_mat(cam, mat_proj);
camera_apply(cam);

draw_clear_alpha(0, 0);
with(grid) {event_perform(ev_draw, 0);}
