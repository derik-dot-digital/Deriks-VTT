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
right = up.Cross(dir).Normalize();

//Camera Settings
fov = 60;
znear = 0.1;
zfar = 100000;
zoom = 200; 
selected_mat = -1;

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

#endregion
#region Input

//Mouse
mouse_pos = new vec2(mouse_x, mouse_y);
mouse_pos_prev = mouse_pos;

#endregion
