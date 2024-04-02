#region Camera 

//Enable 3D
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_alphatestenable(true);
gpu_set_alphatestref(0)
gpu_set_blendenable(true);

//Create Camera Struct
cam = camera_create();

//Stores camera setup in a function so camera can be easily reset
function cam_reset() {

//Camera Vectors
pos = new vec3(0, 200, 100);
target = new vec3(0, 0, 0);
up = new vec3(0, 0, 1);

//Initalize Default Camera Position
dir = pos.Sub(target).Normalize();
view_quat = new quat().FromLookRotation(dir, up);

//Adjust quat to system
var xrot_quat = new quat().FromAngleAxis(0, world_up).Normalize();
var yrot_quat = new quat().FromAngleAxis(0, world_x).Normalize();
view_quat = xrot_quat.Mul(view_quat).Normalize();
view_quat = view_quat.Mul(yrot_quat).Normalize();

//Recalculate vectors
dir = world_up.RotatebyQuat(view_quat).Normalize();
right = world_x.RotatebyQuat(view_quat).Normalize();
up = dir.Cross(right).Normalize();

//Camera Settings
fov = 60;
znear_perspective = 0.1;
zfar = 100000;
znear_ortho = -zfar;
zoom = 200; 
selected_mat = -1;
zoom_strength = 0.01;
projection_slider = 0;

//Store Matrices
mat_view = view_quat.Normalize().AsViewMatrix(pos);
var ww = win_w; var wh = win_h;
aspect = ww/wh;
mat_proj_perspective = matrix_build_projection_perspective_fov(-fov, ww/wh, znear_perspective, zfar);
mat_proj_orthographic = matrix_build_projection_ortho((-ww * 0.001) * zoom,  (-wh * 0.001) * zoom, znear_ortho, zfar);
mat_projection = array_lerp_exp(mat_proj_perspective, mat_proj_orthographic, projection_slider, 5);
}

//Call Function
cam_reset();

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
right_click_open = false;
create_asset_open = false;

//Asset Creation Settings
asset_create_type = 0;
asset_create_name = "Type name here!";
asset_create_filepath = "Copy file path here!";

//Add Fonts
font_default = ImGui.AddFontDefault();
font_dnd = ImGui.AddFontFromFile("fonts/Bookinsanity Bold.ttf", 24);

#endregion
#region Input

//Mouse
mouse_pos = new vec2(mouse_x, mouse_y);
mouse_pos_prev = mouse_pos;

//Asset Transform Axis Lock
asset_axis_lock = new vec3(1, 1, 1);
asset_axis_unlocked = new vec3(1, 1, 1);
asset_pos_prev = new vec3(0, 0, 0);
asset_quat_prev = new quat()
asset_scale_prev = new vec3(1, 1, 1);

#endregion