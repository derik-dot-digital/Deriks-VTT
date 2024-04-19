#region Camera 

//Enable 3D
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_alphatestenable(true);
gpu_set_alphatestref(0);
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

//Scale Vectors
#macro default_scale new vec3(1, 1, 1)

//Matrices
#macro mat_default matrix_build_identity()

//Directorys & File Paths
#macro user_documents directory_get_documents_path()
#macro user_images directory_get_pictures_path()
#macro working_dir directory_get_current_working()
#macro asset_directory working_dir+"assets\\"
#macro default_scene_directory user_documents+"Arcane Engine\\"
if !directory_exists_ns(default_scene_directory) {directory_create_ns(default_scene_directory);}

#endregion
#region GUI 

//Initialize ImGui
ImGui.__Initialize();

//Menu Switches
splash_window = true;
camera_settings_open = false;
grid_settings_open = false;
asset_settings_open = false;
right_click_open = false;
create_asset_open = false;
skybox_settings_open = false;

//Scene Creation 
splash_offset = new vec2(0, 0);
function splash_menu_reset() {
reset_tab_selection = true;
scene_create_directory = default_scene_directory;
scene_create_name = "New Scene";
var default_scene_str = "";
var default_scene_count = 0;
while (file_exists_ns(scene_create_directory+scene_create_name+default_scene_str+".zip")) {
	if default_scene_str = "" {
	default_scene_str = " " + string(default_scene_count);
	} else {
	default_scene_count++;
	default_scene_str = " " + string(default_scene_count);
	}
}
scene_create_name += default_scene_str;
}
splash_menu_reset();

//Asset Creation 
asset_create_type = 0;
asset_create_name = "New Asset";
asset_create_filepath = "Copy file path here!";
asset_create_extension = undefined;

//Saving/Loading 
zip_save_id = undefined;
zip_save_status = undefined;
save_offset = new vec2(0, 0);

//Add Fonts
font_default = ImGui.AddFontDefault();
font_dnd = ImGui.AddFontFromFile("fonts/Bookinsanity Bold.ttf", 24);

#endregion
#region Input

//Mouse
mouse_pos = new vec2(mouse_x, mouse_y);
mouse_pos_prev = mouse_pos;

//Tab Counter
tab_counter = 0;

//Asset Transform Axis Lock
asset_axis_lock = new vec3(1, 1, 1);
asset_axis_unlocked = new vec3(1, 1, 1);
asset_pos_prev = new vec3(0, 0, 0);
asset_quat_prev = new quat()
asset_scale_prev = new vec3(1, 1, 1);

#endregion