#region Input

//Update Mouse Position
mouse_pos = new vec2(mouse_x, mouse_y);

//Distance from previous Mouse Position
var mouse_dx = mouse_pos.x - mouse_pos_prev.x;
var mouse_dy = mouse_pos.y - mouse_pos_prev.y;
var mouse_delta = new vec2(mouse_dx, mouse_dy);

//Scroll Wheel Input
var mouse_scroll = -mouse_wheel_up()+mouse_wheel_down();

//NumPad Input
var numpad = [	keyboard_check_pressed(vk_numpad0),
								keyboard_check_pressed(vk_numpad1), keyboard_check_pressed(vk_numpad2), keyboard_check_pressed(vk_numpad3), 
								keyboard_check_pressed(vk_numpad4), keyboard_check_pressed(vk_numpad5), keyboard_check_pressed(vk_numpad6), 
								keyboard_check_pressed(vk_numpad7), keyboard_check_pressed(vk_numpad8), keyboard_check_pressed(vk_numpad9)];
								
//Zoom +/- Input
var plusminus = -keyboard_check(vk_add)+keyboard_check(vk_subtract);

//Shift Input
var shift = keyboard_check(vk_shift);

//Screen to World Cast
if !ImGui.IsAnyItemHovered() and !ImGui.IsWindowHovered(ImGuiHoveredFlags.AnyWindow) {
	
	//Screen to World Cast
	var stw_cast = mouse_to_world_cast();
	
	//Check Mouse
	if mouse_check_button_pressed(mb_left)  {	
		if stw_cast[0] {
			var hit_object = stw_cast[7];
			var hit_inst = cm_custom_parameter_get(hit_object);
			global.selected_inst = hit_inst;
		} else {
			if global.selection_action = asset_actions.idle {
				global.selected_inst = noone;
			}
			global.selection_action = asset_actions.idle;
		}
	} 
}
	
//Asset Action Detect
if global.selected_inst != noone {
	
	//Axis Lock
	if keyboard_check_released(ord("X")) {
		if asset_axis_lock.Equals(world_x) {
		asset_axis_lock = asset_axis_unlocked;	
		} else {
		asset_axis_lock = world_x;	
		global.selected_inst.pos.y = asset_pos_prev.y;
		global.selected_inst.pos.z = asset_pos_prev.z;
		global.selected_inst.orientation = asset_quat_prev;
		}
	}
	if keyboard_check_released(ord("Y")) {
		if asset_axis_lock.Equals(world_y) {
		asset_axis_lock = asset_axis_unlocked;	
		} else {
		asset_axis_lock = world_y;	
		global.selected_inst.pos.x = asset_pos_prev.x;
		global.selected_inst.pos.z = asset_pos_prev.z;
		global.selected_inst.orientation = asset_quat_prev;
		}
	}
	if keyboard_check_released(ord("Z")) {
		if asset_axis_lock.Equals(world_up) {
		asset_axis_lock = asset_axis_unlocked;	
		} else {
		asset_axis_lock = world_up;	
		global.selected_inst.pos.x = asset_pos_prev.x;
		global.selected_inst.pos.y = asset_pos_prev.y;
		global.selected_inst.orientation = asset_quat_prev;
		}
	}
	
	//Move
	if keyboard_check_released(ord("G")) {
	asset_pos_prev = global.selected_inst.pos; 
	global.selection_action = asset_actions.move;	
	}
	
	//Rotate
	if keyboard_check_released(ord("R")) {
	asset_quat_prev = global.selected_inst.orientation;
	global.selection_action = asset_actions.rotate;	
	}
	
	//Set Camera Target
	if keyboard_check_released(vk_decimal) {
		target = global.selected_inst.pos;	
	}
	
	//Finish Action
	if keyboard_check_released(vk_enter) or mouse_check_button(mb_left) {
	global.selection_action = asset_actions.idle;
	}
	
} 
	
//Asset Actions Apply
if global.selected_inst != noone {
	switch(global.selection_action) {
	
	//Idle
	case (asset_actions.idle):
	asset_pos_prev = global.selected_inst.pos; 
	asset_quat_prev = global.selected_inst.orientation;
	asset_scale_prev = global.selected_inst.scale;
	asset_axis_lock = asset_axis_unlocked;
	break;

	//Move
	case (asset_actions.move):
	
	var move_vec = mouse_delta.AsVec3(0).RotatebyQuat(view_quat).Mul(-zoom*0.002).Mul(asset_axis_lock); //move_vec.z = 0;
	global.selected_inst.pos = global.selected_inst.pos.Add(move_vec);
	
	break;

	//Rotate
	case (asset_actions.rotate):
		
		var rotate_vec = mouse_delta.AsVec3(0).RotatebyQuat(view_quat).Mul(-zoom*0.002).Mul(asset_axis_lock);
	
		//Local Rotation
		if asset_axis_lock.Equals(asset_axis_unlocked) {
			global.selected_inst.orientation = global.selected_inst.orientation.RotateLocalX(rotate_vec.x*0.1);
			global.selected_inst.orientation = global.selected_inst.orientation.RotateLocalY(rotate_vec.y*0.1);
			global.selected_inst.orientation = global.selected_inst.orientation.RotateLocalZ(rotate_vec.z*0.1);
		} else {
			global.selected_inst.orientation = global.selected_inst.orientation.RotateWorldX(rotate_vec.x*0.1);
			global.selected_inst.orientation = global.selected_inst.orientation.RotateWorldY(rotate_vec.y*0.1);
			global.selected_inst.orientation = global.selected_inst.orientation.RotateWorldZ(rotate_vec.z*0.1);
		}
		
		global.selected_inst.orientation = global.selected_inst.orientation.Normalize();
	
	break;

	
	}
}

#endregion
#region Camera

//Camera unlocked bt default
var camera_unlocked = true; 

//Lock Checks
if splash_window {camera_unlocked = false;}

//Check if camera is unlocked
if camera_unlocked {

//Middle Mouse Actions
if mouse_check_button(mb_middle) {
	
	//Directional Pan
	if shift { 
		 
		 //Pan Speed
		 var pan_spd = mouse_delta.Mul(zoom).Mul(0.0015);
		 
		 //Combine Movement
		 var new_axes = new vec3().Add(right.Mul(pan_spd.x)).Add(up.Mul(pan_spd.y));
		 
		 //Move Along Axes
		 target = target.Add(new_axes);
		 
	 } else { 	//Orbital Pan
		
		var xrot_quat = new quat().FromAngleAxis(-mouse_delta.x * 0.003, world_up).Normalize();
		var yrot_quat = new quat().FromAngleAxis(mouse_delta.y  * 0.003, world_x).Normalize();
		view_quat = xrot_quat.Mul(view_quat).Normalize();
		view_quat = view_quat.Mul(yrot_quat).Normalize();
		dir = world_up.RotatebyQuat(view_quat).Normalize();
		right = world_x.RotatebyQuat(view_quat).Normalize();
		
	 }
}

//Scroll Wheel Actions
if mouse_scroll != 0 {
	
	//Zoom
	zoom *= power(zoom, mouse_scroll*zoom_strength);
	
}

//Switch From Perspective to Orthographic
if numpad[5] {
	if round(projection_slider) = 0 {
	projection_slider = 1; 
	} else { 
	projection_slider = 0;	
	}
}

//NumPad Zoom
zoom *= power(zoom, plusminus *zoom_strength);

//Update Mouse Previous Position
mouse_pos_prev = mouse_pos;

} else { //Splash Window
	
	var xrot_quat = new quat().FromAngleAxis(-0.003, world_up).Normalize();
	view_quat = xrot_quat.Mul(view_quat).Normalize();
	dir = world_up.RotatebyQuat(view_quat).Normalize();
	right = world_x.RotatebyQuat(view_quat).Normalize();
	
}

//Update Position
pos = target.Add(dir.Mul(-zoom));

//Update Vectors
up = dir.Cross(right).Normalize();

//Clamp Zoom Values
zoom = max(zoom, 0.1);
zoom_strength = max(zoom_strength, 0.001);

#endregion
#region ImGUI

//Set Font
ImGui.PushFont(font_dnd);

//Splash Window
if splash_window {
	
	var logo_size = new vec2(sprite_get_width(logo), sprite_get_height(logo));
	var logo_scale = 0.4;
	logo_size = logo_size.Mul(logo_scale);
	var splash_pos = new vec2(win_w  / 2, win_h / 2).Sub(splash_offset);
	ImGui.SetNextWindowPos(splash_pos.x, splash_pos.y, ImGuiCond.Always);
	ImGui.Begin("Arcane Engine v0.1", splash_window, ImGuiWindowFlags.Modal | ImGuiWindowFlags.NoNav | ImGuiWindowFlags.NoDecoration | ImGuiWindowFlags.AlwaysAutoResize | ImGuiWindowFlags.NoMove);

	//Logo
	ImGui.Image(logo, 0, c_white, 1, logo_size.x, logo_size.y);
	var splash_w = ImGui.GetWindowWidth();
	ImGui.Separator();

	//Options
	var button_width = ImGui.GetContentRegionAvailX() * 0.2;
	ImGui.SetCursorPosX((splash_w * 0.5)  - (ImGui.CalcTextWidth("Get Started:") * 0.5));
	ImGui.Text("Get Started:");
	ImGui.SetCursorPosX((splash_w * 0.5)  - (1 + (button_width)));
	ImGui.Button("New", button_width); 
	ImGui.SameLine();
	if ImGui.Button("Load", button_width) {
		
		//Select Scene .ZIP
		dm.scene_directory = get_open_filename("", "");
	
		//Check if file exists
		if file_exists(dm.scene_directory) {
			//ADD CHECKS FOR IF FILE IS VALID
			//IF NOT SHOW ERROR AND REMAIN ON SPLASH SCREEN
			
		//Get File Count (.ZIPs are unloaded to working directory)
		var file_count = zip_unzip(dm.scene_directory, working_directory);
		
		//Detect Scene Config 
		var found_config = file_find_first(working_directory + "/*scene_config.ini", fa_none);
		show_debug_message(found_config)
		
		//Load & Apply Config
		if found_config != "" { 

			//Open Config .INI
			ini_open(found_config);
		
			//Camera Data
			view_quat.x = ini_read_real("View Quat", "x", view_quat.x);
			view_quat.y = ini_read_real("View Quat", "y", view_quat.y);
			view_quat.z =  ini_read_real("View Quat", "z", view_quat.z);
			view_quat.w =  ini_read_real("View Quat", "w", view_quat.w);
			pos.x = ini_read_real("Camera Position", "x", pos.x);
			pos.y = ini_read_real("Camera Position", "y", pos.y);
			pos.z = ini_read_real("Camera Position", "z", pos.z);
			target.x = ini_read_real("Camera Target", "x", target.x);
			target.y = ini_read_real("Camera Target", "y", target.y);
			target.z = ini_read_real("Camera Target", "z", target.z);
			dir.x = ini_read_real("Camera Direction", "x", dir.x);
			dir.y = ini_read_real("Camera Direction", "y", dir.y);
			dir.z = ini_read_real("Camera Direction", "z", dir.z);
			up.x = ini_read_real("Camera Up", "x", up.x);
			up.y = ini_read_real("Camera Up", "y", up.y);
			up.z = ini_read_real("Camera Up", "z", up.z);
			fov = ini_read_real("Projection Settings", "fov", fov);
			znear_perspective = ini_read_real("Projection Settings", "znear_perspective", znear_perspective);
			znear_ortho = ini_read_real("Projection Settings", "znear_orthographic", znear_ortho);
			zfar = ini_read_real("Projection Settings", "zfar", zfar);
			projection_slider = ini_read_real("Projection Settings", "projection_slider", projection_slider);
			zoom = ini_read_real("Projection Settings", "zoom", zoom);
			zoom_strength = ini_read_real("Projection Settings", "zoom_strength", zoom_strength);

			//Grid Data
			grid.grid_size = ini_read_real("Grid Settings", "grid_size", grid.grid_size);
			grid.tile_size = ini_read_real("Grid Settings", "tile_size", grid.tile_size);
			grid.depth_mode = ini_read_string("Grid Settings", "depth_mode", grid.depth_mode);
			grid.color_mode = ini_read_real("Grid Settings", "color_mode", grid.color_mode);
			grid.grid_color.x = ini_read_real("Grid Settings", "grid_color_red", grid.grid_color.x);
			grid.grid_color.y = ini_read_real("Grid Settings", "grid_color_green", grid.grid_color.y);
			grid.grid_color.z = ini_read_real("Grid Settings", "grid_color_blue", grid.grid_color.z);
			grid.grid_color.w = ini_read_real("Grid Settings", "grid_color_alpha", grid.grid_color.w);
			grid.rainbow_color_scale = ini_read_real("Grid Settings", "rainbow_color_scale", grid.rainbow_color_scale);
			grid.rainbow_color_spd = ini_read_real("Grid Settings", "rainbow_color_spd", grid.rainbow_color_spd);

			//Close .INI
			ini_close();
			
		}
		
		//Detect Assets
		var found_file = file_find_first(working_directory + "assets/*.ini", fa_none);
		
		//Set Scene name & Directory
		dm.scene_name = filename_name(dm.scene_directory); //Remove Directory
		dm.scene_directory = string_replace(dm.scene_directory, dm.scene_name, ""); //Remove .ZIP name from the path chosen earlier
		dm.scene_name = string_replace(dm.scene_name, ".zip", ""); //Remove file extension
		
		//Store Found .INI files in list
		while (found_file != "")
		{
			ds_list_add(dm.asset_list, working_directory + "assets/" + found_file);
			found_file = file_find_next();
		}
		
		//Close out file search
		file_find_close();
				 
		//Spawn Assets
		for (var i = 0; i < ds_list_size(dm.asset_list); i++) {
			
			//Store Current .INI path
			var current_ini = ds_list_find_value(dm.asset_list, i)
			
			//Open Asset .INI
			ini_open(current_ini);
			
			//Spawn Instance
			var asset_inst = instance_create_depth(0, 0, 0, asset);
			
			//Load Data & Apply to Instance
			asset_inst.name = ini_read_string("Data", "name", "undefined");
			asset_inst.type = ini_read_real("Data", "type", 0);
			asset_inst.file_path = ini_read_string("Data", "path", "undefined");
			asset_inst.file_extension = str_check_compatable_file_type(asset_inst.file_path);
			asset_inst.pos.x = ini_read_real("Position", "x", 0);
			asset_inst.pos.y = ini_read_real("Position", "y", 0);
			asset_inst.pos.z = ini_read_real("Position", "z", 0);
			asset_inst.orientation.x = ini_read_real("Orientation", "x", 0);
			asset_inst.orientation.y = ini_read_real("Orientation", "y", 0);
			asset_inst.orientation.z = ini_read_real("Orientation", "z", 0);
			asset_inst.orientation.w = ini_read_real("Orientation", "w", 1);
		
			//Close .INI
			ini_close();
				
		}
			
		//Fresh .ZIP for session
		dm.scene_zip = zip_create();
		
		//Reset Scene Creation Settings (Incase they were changed before loading)
		scene_create_name = "New Scene";
		scene_create_directory = "Copy file path here!";
		
		//Exit Splash Window
		splash_window = false;
		
		} else {
			//Need to show an error or something
		}	
	}
	
	//File Name
	ImGui.Text("Scene Name:");
	ImGui.PushItemWidth(splash_w-15.1);
	scene_create_name = ImGui.InputText("", scene_create_name);
	
	//File Directory
	var allow_new_scene = false;
	ImGui.Text("File Path:");
	ImGui.PushItemWidth(splash_w-50);
	scene_create_directory = ImGui.InputText("##label File Path", scene_create_directory); ImGui.SameLine();
	if (ImGui.ImageButton("File Picker Button", spr_file_icon, 0, c_white, 1, c_white, 0, 18, 18)) {
		var _dir_result = get_directory("Save Directory");
		if string_length(_dir_result) > 0 {
		scene_create_directory = _dir_result;
		}
	} 
	ImGui.PopItemWidth();
	var allow_new_scene = true;
	if scene_create_directory != "Copy file path here!"  {
	//Do Nothing
	} else {ImGui.TextColored("**Required", c_white, 1); allow_new_scene = false;}
	//ImGui.Separator();	

	var button_disabled = true; if allow_new_scene {button_disabled = false;}
	ImGui.BeginDisabled(button_disabled);
	ImGui.SetCursorPosX((splash_w * 0.5)  - (1 + (button_width * 0.5)));
	if ImGui.Button("Create", button_width) {
		
		//Exit Splash Window
		splash_window = false;
		
		//Store Scene Name
		dm.scene_name = scene_create_name;
		
		//Store Scene Save Directory
		dm.scene_directory = scene_create_directory;
		
		//Store Scene Save .ZIP
		dm.scene_zip = zip_create();
		
		//Reset Scene Creation Settings
		scene_create_name = "New Scene";
		scene_create_directory = "Copy file path here!";
		
	}
	ImGui.EndDisabled();
	
	//Update Center Offset
	splash_offset = new vec2(ImGui.GetWindowWidth(), ImGui.GetWindowHeight()).Mul(0.5);
	
	ImGui.End();
	
} 
else  //Everything else
{

#region Tool Bar
ImGui.BeginMainMenuBar();

//File Tab
if (ImGui.BeginMenu("File")) {
	if (ImGui.MenuItem("New Scene")) {
		//Clear Scene
		//Offer to save
	}
	if (ImGui.MenuItem("Open Scene")) {
		//Load Scene
		//Offer to save
	}
	if (ImGui.MenuItem("Import Scene")) {
		//Import Scene to add to Current
		//Offer to save backup
	}
	if (ImGui.MenuItem("Recent Scenes")) {
		//Show list of Recent Scenes which trigger a scene load if selected
	}
	ImGui.Separator();
	if (ImGui.MenuItem("Save Scene")) {
		
		//Save Scene Config
		with(camera) {event_user(0);}
		
		//Add Assets to .ZIP
		with(asset) {event_user(0);}

		//Save .ZIP
		zip_save(dm.scene_zip, dm.scene_directory + dm.scene_name + ".zip")
		
	}
	if (ImGui.MenuItem("Save Scene As")) {
		//Save Scene with a new name
	}
	ImGui.EndMenu();
}

//Edit Tab
if (ImGui.BeginMenu("Edit")) {
	if (ImGui.MenuItem("Undo")) {
		//Todo
	}
	if (ImGui.MenuItem("Redo")) {
		//Todo
	}
	if (ImGui.MenuItem("Search")) {
		//Todo
	}
	ImGui.EndMenu();
}

//Windows Tab
if (ImGui.BeginMenu("Windows")) {
	if (ImGui.MenuItem("Camera")) {
		if !camera_settings_open {camera_settings_open = true;}
	}
	if (ImGui.MenuItem("Grid")) {
		if !grid_settings_open {grid_settings_open = true;}
	}
	if (ImGui.MenuItem("Assets")) {
		if !asset_settings_open {asset_settings_open = true;}
	}
	ImGui.EndMenu();
}

//Add Shortcut Buttons

//End Tool Bar
ImGui.EndMainMenuBar();

#endregion

//Camera Panel
if camera_settings_open {	

	//Close Window
	var ret = ImGui.Begin("Camera", camera_settings_open, ImGuiWindowFlags.AlwaysAutoResize, ImGuiReturnMask.Both);
	camera_settings_open = ret & ImGuiReturnMask.Pointer;

	//View Quaternion
	var view_quat_array = [[view_quat.x, view_quat.y], [view_quat.z, view_quat.w]];
	ImGui.InputFloat2("View Quaternion X/Y (Read Only)", view_quat_array[0],,,,ImGuiInputTextFlags.ReadOnly);
	ImGui.InputFloat2("View Quaternion Z/W (Read Only)", view_quat_array[1],,,,ImGuiInputTextFlags.ReadOnly);
	
	//Camera Position
	var pos_array = pos.AsLinearArray();
	ImGui.InputFloat3("Camera Position  (Read Only)", pos_array,,,,ImGuiInputTextFlags.ReadOnly);
	
	//Camera Target
	var target_array = target.AsLinearArray();
	ImGui.InputFloat3("Target Position", target_array);
	target.x = target_array[0]; target.y = target_array[1]; target.z = target_array[2];
	
	//Camera Position
	var dir_array = dir.AsLinearArray();
	ImGui.InputFloat3("Camera Direction (Read Only)", dir_array,,,,ImGuiInputTextFlags.ReadOnly);

	//Camera Up Vector
	var up_array = up.AsLinearArray();
	ImGui.InputFloat3("Camera Up (Read Only)", up_array,,,,ImGuiInputTextFlags.ReadOnly);

	//FOV
	fov = ImGui.InputFloat("Field of View", fov, 1, 5);
	if fov = 0 {fov += choose(-0.1, 0.1);}
	
	//ZNear
	znear_perspective = ImGui.InputFloat("ZNear Perspective", znear_perspective, 0.01, 0.1);
	znear_ortho = ImGui.InputFloat("ZNear Orthographic", znear_ortho, 0.01, 0.1);
	
	//ZFar
	zfar = ImGui.InputFloat("ZFar", zfar, 0.01, 0.1);
	
	//Projection Slider
	projection_slider = ImGui.SliderFloat("Projection Type", projection_slider, 0, 1);
	
	//Zoom
	zoom = ImGui.InputFloat("Zoom", zoom, 1, 5);
	
	//Zoom Strength
	zoom_strength = ImGui.InputFloat("Zoom Strength", zoom_strength, 0.005,  0.005); 
	
	//Reset Camera
	if ImGui.Button("Reset to Default") {cam_reset();}
	
	//End Menu
	ImGui.End();

}

//Grid Panel
if grid_settings_open {	

	//Setting Updated
	var regenerate_buffer = 0;
	
	//Close Window
	var ret = ImGui.Begin("Grid", grid_settings_open, ImGuiWindowFlags.AlwaysAutoResize, ImGuiReturnMask.Both);
	grid_settings_open = ret & ImGuiReturnMask.Pointer;

	//Tile size
	var prev_grid_size = grid.grid_size;
	grid.grid_size = ImGui.InputInt("Grid Size", grid.grid_size, 1, 10);
	if grid.grid_size != prev_grid_size {regenerate_buffer = 1;}
	
	//Tile size
	var prev_tile_size = grid.tile_size;
	grid.tile_size = ImGui.InputInt("Tile Size", grid.tile_size, 1, 10);
	if grid.tile_size != prev_tile_size {regenerate_buffer = 1;}

	//Grid Depth Mode
	var grid_depth_mode_str = ["Default", "Always Behind", "Always Above"];
	var grid_depth_mode_open = ImGui.BeginCombo("Depth Mode", grid.depth_mode, ImGuiComboFlags.None);
	if grid_depth_mode_open {
		for (var i = 0; i < array_length(grid_depth_mode_str); i++) {
			var item = ImGui.Selectable(grid_depth_mode_str[i],,ImGuiSelectableFlags.None);
			if item = true {
				grid.depth_mode = grid_depth_mode_str[i]; 
			}
		}
	ImGui.EndCombo();
	}
	
	//Grid Color Mode
	var color_mode_str = ["Solid", "Rainbow Solid", "Rainbow Wave"];
	var grid_color_mode_open = ImGui.BeginCombo("Color Mode", color_mode_str[grid.color_mode], ImGuiComboFlags.None);
	if grid_color_mode_open {
		for (var i = 0; i < array_length(color_mode_str); i++) {
			var item = ImGui.Selectable(color_mode_str[i],,ImGuiSelectableFlags.None);
			if item = true {
				grid.color_mode = i; 
			}
		}
	ImGui.EndCombo();
	}
	
	//Grid Overlay Mode
	//grid.overlay_mode = ImGui.Checkbox("Overlay Mode", grid.overlay_mode);
	
	//Grid Color Picker
	if grid.color_mode = grid_color_mode.solid {
		var color_picker_open = ImGui.TreeNodeEx("Color Picker", ImGuiTreeNodeFlags.Framed | ImGuiTreeNodeFlags.NoTreePushOnOpen);
		if color_picker_open {
			var grid_col = grid.grid_color;
			grid_col = grid_col.Mul(255);
			grid_col.w = grid.grid_color.w;
			var grid_color_struct = new ImColor(grid_col.x, grid_col.y, grid_col.z, grid_col.w);
			ImGui.ColorPicker4("Grid Color", grid_color_struct, ImGuiColorEditFlags.AlphaBar);
			grid.grid_color = new vec4(grid_color_struct.r, grid_color_struct.g, grid_color_struct.b, grid_color_struct.a).ColortoShader();
			ImGui.Separator();
		}
		ImGui.TreePop();
		if !color_picker_open {
			grid.grid_color.w = ImGui.SliderFloat("Alpha", grid.grid_color.w, 0, 1);
		}
	} 
	
	//Rainbow Color Scale
	if  grid.color_mode = grid_color_mode.rainbow_wave {
		grid.rainbow_color_scale = ImGui.InputFloat("Rainbow Scale", grid.rainbow_color_scale, 0.001, 0.01);
	}
	
	//Rainbow Color Speed
	if grid.color_mode = grid_color_mode.rainbow_solid or grid.color_mode = grid_color_mode.rainbow_wave {
		grid.rainbow_color_spd = ImGui.InputFloat("Rainbow Speed", grid.rainbow_color_spd, 0.01, 0.1);
		grid.grid_color.w = ImGui.SliderFloat("Alpha", grid.grid_color.w, 0, 1);
	}

	//Force vBuffer regeneration
	if regenerate_buffer {with(grid) {update_grid();}}
	
	//End Menu
	ImGui.End();
	
}
 
 //Asset Panel
 if asset_settings_open {
	 
	//Close Window
	var ret = ImGui.Begin("Asset", asset_settings_open, ImGuiWindowFlags.AlwaysAutoResize, ImGuiReturnMask.Both);
	asset_settings_open = ret & ImGuiReturnMask.Pointer;
	
	//Nothing Selected
	if global.selected_inst = noone {
		ImGui.Text("Select an asset to view.");	
	} else { //Asset Selected
		
		//Grab Instance Reference	
		var inst = global.selected_inst;
		
		//Name
		inst.name = ImGui.InputText("Name", inst.name);
		
		//Asset Type
		var asset_type_str = ["Empty", "Map", "Art", "Player", "NPC"]
		var asset_type_open = ImGui.BeginCombo("Asset Type", asset_type_str[inst.type], ImGuiComboFlags.None);
		if asset_type_open {
			for (var i = 0; i < array_length(asset_type_str); i++) {
				var item = ImGui.Selectable(asset_type_str[i],,ImGuiSelectableFlags.None);
				if item = true {
					inst.type = i; 
				}
			}
		ImGui.EndCombo();
		}
		
		var transform_tree_open = ImGui.TreeNodeEx("Transform", ImGuiTreeNodeFlags.NoTreePushOnOpen);
		if transform_tree_open {
			
		//Position
		var pos_array = inst.pos.AsLinearArray();
		ImGui.InputFloat3("Position", pos_array);
		inst.pos.x = pos_array[0]; inst.pos.y = pos_array[1]; inst.pos.z = pos_array[2];
	
		//Orientation Quat
		var orientation_quat_array = [[inst.orientation.x, inst.orientation.y], [inst.orientation.z, inst.orientation.w]];
		ImGui.InputFloat2("Orientation Quaternion X/Y", orientation_quat_array[0],,,,ImGuiInputTextFlags.None);
		ImGui.InputFloat2("Orientation Quaternion Z/W", orientation_quat_array[1],,,,ImGuiInputTextFlags.None);
		inst.orientation = new quat(orientation_quat_array[0][0], orientation_quat_array[0][1], orientation_quat_array[1][0], orientation_quat_array[1][1]);
	
		//Scale
		var scale_array = inst.scale.AsLinearArray();
		ImGui.InputFloat3("Scale", scale_array);
		inst.scale.x = scale_array[0]; inst.scale.y = scale_array[1]; inst.scale.z = scale_array[2];
		
		}

		ImGui.TreePop();
		
	}
	//End Menu
	ImGui.End();
	
 }
 
//Right Click Context Menu
if mouse_check_button_released(mb_right) {
	right_click_open = true;
	ImGui.SetNextWindowPos(window_mouse_get_x(), window_mouse_get_y());
}
if right_click_open {
	if (ImGui.Begin("right_click", right_click_open, ImGuiWindowFlags.AlwaysAutoResize | ImGuiWindowFlags.NoDecoration | ImGuiWindowFlags.NoMove)) {
	
		//Roll Die
		if (ImGui.MenuItem("Roll Die")){
			//Add functionality for rolling a 3D die with options for all die + physics
			right_click_open = false;
		}
		
		//Create New Asset
		if (ImGui.MenuItem("Create New Asset")) and !create_asset_open{
			create_asset_open = true;
			ImGui.SetNextWindowPos(mouse_x, mouse_y);
			right_click_open = false;
		}
		
		//Create Primitive
		if (ImGui.MenuItem("Create Primitive")){
			//Add functionality for spawning 3D primitives
			right_click_open = false;
		}
		
	}
	if !ImGui.IsWindowHovered() and mouse_check_button(mb_left) {right_click_open = false;}
	ImGui.End();
}

//Create Asset
if create_asset_open {
	if (ImGui.Begin("Create Asset",, ImGuiWindowFlags.AlwaysAutoResize | ImGuiWindowFlags.NoDecoration)) {
		
	//Asset Name
	ImGui.Text("Asset Name:");
	asset_create_name = ImGui.InputText("##label Asset Name", asset_create_name);
	ImGui.Separator();	
	
	//Asset Type
	ImGui.Text("Asset Type:");
	if (ImGui.RadioButton("Art", asset_create_type == 0)) {asset_create_type = 0;} ImGui.SameLine();
	if (ImGui.RadioButton("Map", asset_create_type == 1)) {asset_create_type = 1;} ImGui.SameLine();
	if (ImGui.RadioButton("Player", asset_create_type == 2)) {asset_create_type = 2;} ImGui.SameLine();
	if (ImGui.RadioButton("NPC", asset_create_type == 3)) {asset_create_type = 3;}
	ImGui.Separator();	
	
	//Asset File
	ImGui.Text("File Path:");
	asset_create_filepath = ImGui.InputText("##label File Path", asset_create_filepath); ImGui.SameLine();
	if (ImGui.ImageButton("File Picker Button", spr_file_icon, 0, c_white, 1, c_white, 0, 18, 18)) {asset_create_filepath = get_open_filename("", "");} //Add Supported Files to filter one day
	var allow_creation = true;
	if asset_create_filepath != "Copy file path here!"  {
		if file_exists(asset_create_filepath) {
		asset_create_extension = str_check_compatable_file_type(asset_create_filepath);
		if asset_create_extension = undefined {
		ImGui.TextColored("**Invalid File Type", c_red, 1);	
		allow_creation = false;
		}
		} else {
			ImGui.TextColored("**File not found", c_red, 1);
			allow_creation = false;
		}
	} else {ImGui.TextColored("**Required", c_white, 1); allow_creation = false;}
	ImGui.Separator();	
	
	//Create		
	var button_disabled = false; if !allow_creation {button_disabled = true;}
	ImGui.BeginDisabled(button_disabled);
	if (ImGui.Button("Create")  and allow_creation) {
		var new_inst = instance_create_depth(0, 0, 0, asset);
		new_inst.name = asset_create_name;
		new_inst.type = asset_types.art;
		new_inst.file_path = asset_create_filepath;
		new_inst.file_extension = asset_create_extension;
		
		//Reset Values
		asset_create_type = 0;
		asset_create_name = "Type name here!";
		asset_create_filepath = "Copy file path here!";
		asset_create_extension = undefined;
		
		//Close Menu
		create_asset_open = false;
		
	} 
	 ImGui.SameLine();
	ImGui.EndDisabled();
	
	//Canceled		
	if (ImGui.Button("Cancel")) {

		//Reset Values
		asset_create_type = 0;
		asset_create_name = "Type name here!";
		asset_create_filepath = "Copy file path here!";
		asset_create_extension = undefined;
		
		//Close Menu
		create_asset_open = false;
		
	} 
	
	}
	ImGui.End();
}

}

#endregion