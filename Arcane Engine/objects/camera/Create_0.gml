gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
cam = camera_create();
target = new vec3(0.0, 0.0, 0.0);
cam_dist = 200;
pos = target.Add(cam_dist);
pos.z = cam_dist / 2;
fov = 60;
#macro win_w window_get_width()
#macro win_h window_get_height()
znear = 0.1;
zfar = 100000;