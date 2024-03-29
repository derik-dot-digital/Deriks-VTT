#region Camera 

//Enable 3D
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

//Create Camera Struct
cam = camera_create();

//Camera Vectors
pos = new vec3(0, 200, 100);
target = new vec3(0, 0, 0);
up = new vec3(0, 0, 1);
dir = pos.Sub(target).Normalize();
view_quat = new quat().FromLookRotation(dir, up);
var xrot_quat = new quat().FromAngleAxis(0, world_up).Normalize();
var yrot_quat = new quat().FromAngleAxis(0, world_x).Normalize();
view_quat = xrot_quat.Mul(view_quat).Normalize();
view_quat = view_quat.Mul(yrot_quat).Normalize();
dir = world_up.RotatebyQuat(view_quat).Normalize();
right = world_x.RotatebyQuat(view_quat).Normalize();
up = dir.Cross(right).Normalize();

//Camera Settings
fov = 60;
znear = 0.0001;
zfar = 100000;
zoom = 200; 
selected_mat = -1;
zoom_strength = 0.01;
projection_slider = 0;

//Store Matrices
mat_view = view_quat.Normalize().AsMatrix(pos);
var ww = win_w; var wh = win_h;
aspect = ww/wh;
mat_proj_perspective = matrix_build_projection_perspective_fov(-fov, ww/wh, znear, zfar);
mat_proj_orthographic = matrix_build_projection_ortho((-ww * 0.001) * zoom,  (-wh * 0.001) * zoom, znear, zfar);

#endregion
#region Macros

//Window Size
#macro win_w max(window_get_width(), 2)
#macro win_h max(window_get_height(), 2)

//World Vectors
#macro world_up new vec3(0, 0, 1)
#macro world_x new vec3(1, 0, 0)
#macro world_y new vec3(0, 1, 0)
#macro world_down new vec3(0, 0, -1)

#endregion
#region GUI 

//Initialize ImGui
ImGui.__Initialize();

//Store Open Menu Status
camera_settings_open = false;
grid_settings_open = false;

#endregion
#region Input

//Mouse
mouse_pos = new vec2(mouse_x, mouse_y);
mouse_pos_prev = mouse_pos;

#endregion