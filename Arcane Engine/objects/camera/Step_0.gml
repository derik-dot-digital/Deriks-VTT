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

//Arrow Keys Input
var up_key = keyboard_check_pressed(vk_up);
var down_key = -keyboard_check_pressed(vk_down);
var left_key = keyboard_check_pressed(vk_left);
var right_key = -keyboard_check_pressed(vk_right);
var arrow_keys_vec = new vec2(left_key+right_key, up_key+down_key);

//Clear Inputs
if ImGui.IsAnyItemFocused() or ImGui.IsAnyItemActive() {
	shift = 0;
	plusminus = 0;
	numpad = array_create(10, 0);
	//mouse_scroll = 0;
} else {
	
	//Tab through assets
	if keyboard_check_released(vk_tab) {
		var asset_count = instance_number(asset) - 1;
		tab_counter++;
		if tab_counter > asset_count {tab_counter = 0;}
		global.selected_inst = instance_find(asset, tab_counter);
	}
}

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
if global.selected_inst != noone and !ImGui.IsAnyItemFocused() {
	
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
	
	//Delete
	if keyboard_check_released(ord("X")) and keyboard_check(vk_control) {
	instance_destroy(global.selected_inst);
	global.selected_inst = noone;
	global.selection_action = asset_actions.idle;
	}
	
	//Finish Action
	if keyboard_check_released(vk_enter) or mouse_check_button(mb_left) {
	global.selection_action = asset_actions.idle;
	}
	
} 
	
//Asset Actions Apply
if global.selected_inst != noone  {
	switch(global.selection_action) {
	
	//Idle
	case (asset_actions.idle):
	asset_pos_prev = global.selected_inst.pos; 
	asset_quat_prev = global.selected_inst.orientation;
	asset_scale_prev = global.selected_inst.scale;
	asset_axis_lock = asset_axis_unlocked;
	
	//Basic Grid Movement with Arrow-Keys
	if arrow_keys_vec.Magnitude() !=  0 {
	global.selected_inst.pos = global.selected_inst.pos.Add(arrow_keys_vec.AsVec3(0).RotatebyQuat(view_quat).Mul(grid.tile_size*0.5));
	global.selected_inst.pos = global.selected_inst.pos.Snapped(new vec3(grid.tile_size, grid.tile_size, grid.tile_size).Mul(0.5));
	}
	
	break;

	//Move
	case (asset_actions.move):
	var move_vec = mouse_delta.AsVec3(0).RotatebyQuat(view_quat).Mul(-zoom*0.002).Mul(asset_axis_lock); 
	global.selected_inst.pos = global.selected_inst.pos.Add(move_vec);
	if keyboard_check(vk_shift) {
	global.selected_inst.pos = global.selected_inst.pos.Snapped(new vec3(grid.tile_size, grid.tile_size, grid.tile_size).Mul(0.5));
	}
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

//Save Shortcut
if zip_save_status = undefined {
	if keyboard_check(vk_control) and keyboard_check_released(ord("S")) and dm.scene_zip != undefined {
		save_scene();
	}
}

#endregion
#region Camera

//Camera unlocked bt default
var camera_unlocked = true; 

//Lock Checks
if splash_window {camera_unlocked = false;}
if zip_save_status != undefined {camera_unlocked = false;}

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
	
//Align Camera to World -Z Shortcut
if numpad[7] {
	dir = world_down.Normalize();
	view_quat =  view_quat.FromLookRotation(world_up, world_x).Normalize();
	right = world_x.Normalize();
	up = dir.Cross(right).Normalize();
	dir = world_up.RotatebyQuat(view_quat).Normalize();
	right = world_x.RotatebyQuat(view_quat).Normalize();
	projection_slider = 1;
}
//Align Camera to World X Shortcut
if numpad[3] {
	dir = world_x.Negate().Normalize();
	view_quat =  view_quat.FromLookRotation(world_x.Negate(), world_up).Normalize();
	right = world_y.Normalize();
	up = dir.Cross(right).Normalize();
	dir = world_up.RotatebyQuat(view_quat).Normalize();
	right = world_x.RotatebyQuat(view_quat).Normalize();
	projection_slider = 1;
}
//Align Camera to World -Y Shortcut
if numpad[1] {
	dir = world_y.Normalize();
	view_quat =  view_quat.FromLookRotation(world_y, world_up).Normalize();
	right = world_x.Normalize();
	up = dir.Cross(right).Normalize();
	dir = world_up.RotatebyQuat(view_quat).Normalize();
	right = world_x.RotatebyQuat(view_quat).Normalize();
	projection_slider = 1;
}
//Align Camera to World -X Shortcut
if numpad[9] {
	dir = world_x.Normalize();
	view_quat =  view_quat.FromLookRotation(world_x, world_up).Normalize();
	right = world_y.Normalize();
	up = dir.Cross(right).Normalize();
	dir = world_up.RotatebyQuat(view_quat).Normalize();
	right = world_x.RotatebyQuat(view_quat).Normalize();
	projection_slider = 1;
}

//Rotate Camera around View Up
var numpad_uprot = numpad[6] - numpad[4];
if numpad_uprot != 0 {
	var xrot_quat = new quat().FromAngleAxis(numpad_uprot * degtorad(90/3), world_up).Normalize();
	view_quat = xrot_quat.Mul(view_quat).Normalize();
	dir = world_up.RotatebyQuat(view_quat).Normalize();
	right = world_x.RotatebyQuat(view_quat).Normalize();
}

//Rotate Camera around View Right
var numpad_rightrot = numpad[8] - numpad[2];
if numpad_rightrot != 0 {
	var yrot_quat = new quat().FromAngleAxis(numpad_rightrot * degtorad(90/3), world_x).Normalize();
	view_quat = view_quat.Mul(yrot_quat).Normalize();
	dir = world_up.RotatebyQuat(view_quat).Normalize();
	right = world_x.RotatebyQuat(view_quat).Normalize();
}

//NumPad Zoom
zoom *= power(zoom, plusminus *zoom_strength);

//Update Mouse Previous Position
mouse_pos_prev = mouse_pos;

} 
else if splash_window { //Splash Window
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
	if (ImGui.BeginTabBar("Splash Menu Options")) {

    if (ImGui.BeginTabItem("New")) or reset_tab_selection
        {
			
			var allow_new_scene = true;
						
			//File Name
			ImGui.Text("Scene Name:");
			ImGui.PushItemWidth(splash_w-15.1);
			scene_create_name = ImGui.InputText("##label scene creation name", scene_create_name);
			if file_exists_ns(scene_create_directory+scene_create_name+".zip") {
				allow_new_scene = false;
				ImGui.TextColored("**Scene name already in use in this directory", c_red, 1);
			}
			
			//Save Directory
			ImGui.Text("Save Directory:");
			ImGui.PushItemWidth(splash_w-28-ImGui.GetFrameHeight());
			scene_create_directory = ImGui.InputText("##label File Path", scene_create_directory); ImGui.SameLine();
			
			if (ImGui.ImageButton("File Picker Button", spr_file_icon, 0, c_white, 1, c_white, 0, ImGui.GetFrameHeight(), ImGui.GetFrameHeight())) {
				var _dir_result = get_directory("Save Directory");
				if string_length(_dir_result) > 0 {
				scene_create_directory = _dir_result;
				}
			} 
			ImGui.PopItemWidth();
			if scene_create_directory = default_scene_directory {
			ImGui.TextColored("**Required", c_white, 1); 
			}
			if !directory_exists_ns(scene_create_directory) {ImGui.TextColored("**Directory does not exist.", c_red, 1);}		

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
				
				//Reset Camera
				cam_reset();
				
				//Reset Splash Menu
				splash_menu_reset();
		
			}
			ImGui.EndDisabled();
			
            ImGui.EndTabItem();
        }
	if (ImGui.BeginTabItem("Load"))
    {
		ImGui.Text("Recent Scenes:");
		ImGui.SameLine();
		ImGui.SetCursorPosX(((splash_w-button_width)-ImGuiStyleVar.FramePadding)+3)
		if ImGui.Button("Open", button_width) {load_scene();}
		ImGui.Separator();
		ImGui.BeginListBox("##label recent scenes", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
		var first_result = file_find_first_ns(default_scene_directory + "/*.zip");
		var current_result = first_result
		while current_result != "" {
				var scene_selected = ImGui.Selectable(filename_name(current_result),,ImGuiSelectableFlags.AllowDoubleClick);
				//See if you can make this work on a double click instead of a single
				if scene_selected {load_scene(default_scene_directory + current_result); splash_menu_reset(); break;}
				current_result = file_find_next_ns();
		}
		file_find_close_ns()
		ImGui.EndListBox();
        ImGui.EndTabItem();
    }
		
	//Allows Tab Selected to be reset on splash_reset();
	reset_tab_selection = false;
	
	ImGui.EndTabBar();
	}
		
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
		//Add Confirmation/Save Current popup
		clear_scene();
		cam_reset();
		splash_menu_reset();
		splash_window = true;
	}
	if (ImGui.MenuItem("Open Scene")) {
		//Add Confirmation/Save Current popup
		load_scene();
	}
	if (ImGui.MenuItem("Import Scene")) {
		//Add Confirmation/Save Current popup
		//Import Scene to add to Current
		load_scene(undefined, true);
	}
	if (ImGui.BeginMenu("Recent Scenes")) {
		
		//TODO: Add Save Confirmation
		var first_result = file_find_first_ns(default_scene_directory + "/*.zip");
		var current_result = first_result
		while current_result != "" {
				var display_str = string_replace(current_result, ".zip", "");
				var scene_selected = ImGui.MenuItem(filename_name(display_str));
				if scene_selected {load_scene(default_scene_directory + current_result); splash_menu_reset(); break;}
				current_result = file_find_next_ns();
		}
		file_find_close_ns()

		ImGui.EndMenu();
	}
	ImGui.Separator();
	if (ImGui.MenuItem("Save Scene")) {
		save_scene();
	}
	if (ImGui.MenuItem("Save Scene As")) {
		var new_dir = get_directory("Save Directory");
		if new_dir != "" {
			dm.scene_directory = new_dir;
			save_scene();
		}
	}
	ImGui.Separator();
	if (ImGui.MenuItem("Exit")) {
		//TODO: Add save/confirmation popup
		game_end();	
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
	if (ImGui.MenuItem("Skybox")) {
		if !skybox_settings_open {skybox_settings_open = true;}	
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

	//Enable/Disable
	grid.enabled = ImGui.Checkbox("Enable/Disable", grid.enabled);

	//Tile size
	var prev_grid_size = grid.grid_size;
	grid.grid_size = ImGui.InputInt("Grid Size", grid.grid_size, 1, 10);
	if grid.grid_size != prev_grid_size {regenerate_buffer = 1;}
	
	//Tile size
	var prev_tile_size = grid.tile_size;
	grid.tile_size = ImGui.InputInt("Tile Size", grid.tile_size, 1, 10);
	if grid.tile_size != prev_tile_size {regenerate_buffer = 1;}

	//Grid Depth Mode
	var grid_depth_mode_str = ["Default", "Always Behind", "Always Above", "Overlay"];
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
		
	//Name (Avoids Duplicates)
	var new_name = ImGui.InputText("Name", inst.name);
	var name_taken = false;
	for (var i = 0; i < instance_number(asset); i++) {
		var _inst = instance_find(asset, i);
		if _inst != global.selected_inst {
			if new_name = _inst.name{
			name_taken = true;	
			}
		}
	}
	if !name_taken {inst.name = new_name}else{ImGui.TextColored("**Duplicate name, will not be applied.", c_red, 1);}
		
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
	
	//Image Settings
	if sprite_exists(inst.art) {
		var image_tree_open = ImGui.TreeNodeEx("Image", ImGuiTreeNodeFlags.CollapsingHeader);
		if image_tree_open {
			
		//Resolution
		var resolution_array = [inst.art_w, inst.art_h];
		ImGui.InputFloat2("Resolution", resolution_array, 0.1, 1);
		inst.art_w = resolution_array[0]; inst.art_h = resolution_array[1];

		}	
	}

	//Transform
	var transform_tree_open = ImGui.TreeNodeEx("Transform", ImGuiTreeNodeFlags.CollapsingHeader);
	if transform_tree_open {
		
		//Position
		var pos_array = inst.pos.AsLinearArray();
		ImGui.InputFloat3("Position", pos_array);
		inst.pos.x = pos_array[0]; inst.pos.y = pos_array[1]; inst.pos.z = pos_array[2];
	
		//Orientation/Rotation
		var orientation_as_euler_array = inst.orientation.ToEulerAngles().AsLinearArray();
		ImGui.InputFloat3("Rotation", orientation_as_euler_array,,,,ImGuiInputTextFlags.None);
		inst.orientation = new quat().FromEulerAngles(new vec3(orientation_as_euler_array[0], orientation_as_euler_array[1], orientation_as_euler_array[2])).Normalize();
	
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
 
 //Skybox Panel
if skybox_settings_open {	

	//Close Window
	var ret = ImGui.Begin("Skybox", skybox_settings_open, ImGuiWindowFlags.AlwaysAutoResize, ImGuiReturnMask.Both);
	skybox_settings_open = ret & ImGuiReturnMask.Pointer;
	
	//Enable/Disable
	skybox.enabled = ImGui.Checkbox("Enable/Disable", skybox.enabled);
	
	//Grid Depth Mode
	skybox_mode_str_array = ["Solid Color", "Solid Rainbow", "Rainbow Wave", "Dynamic", "Cubemap", "HDRI"];
	var skybox_mode_open = ImGui.BeginCombo("Mode", skybox_mode_str_array[skybox.mode], ImGuiComboFlags.None);
	if skybox_mode_open {
		for (var i = 0; i < array_length(skybox_mode_str_array); i++) {
			var item = ImGui.Selectable(skybox_mode_str_array[i],,ImGuiSelectableFlags.None);
			if item = true {skybox.mode = i;}
		}
	ImGui.EndCombo();
	}
	
	
	//Dynamic Blend Mode
	if skybox.mode = skybox_modes.dynamic {
		dynamic_style_str_array = ["Solid", "Gradient"];
		var skybox_mode_open = ImGui.BeginCombo("Style", dynamic_style_str_array[skybox.dynamic_style], ImGuiComboFlags.None);
		if skybox_mode_open {
			for (var i = 0; i < array_length(dynamic_style_str_array); i++) {
				var item = ImGui.Selectable(dynamic_style_str_array[i],,ImGuiSelectableFlags.None);
				if item = true {skybox.dynamic_style = i;}
			}
		ImGui.EndCombo();
		}
	}
	
	//HDRI Mode
	if skybox.mode = skybox_modes.hdri {
	
	//HDRI Selection
	skybox.hdri_index = ImGui.InputInt("Style", skybox.hdri_index, 1, 1);
		
	}
	
	
	//Solid Color
	switch (skybox.mode) 
	{
	
		//Solid Color
		case (skybox_modes.solid_color):
		ImGui.Text("Skybox Color:");
		skybox.color = ImGui.ColorPicker3("Skybox Color", skybox.color);
		break;

		//Solid Rainbow
		case (skybox_modes.solid_rainbow):
		skybox.rainbow_spd = ImGui.InputFloat("Rainbow Speed", skybox.rainbow_spd, 0.01, 0.1);
		break;

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
		
	//Asset Name (Avoids Duplicates)
	ImGui.Text("Asset Name:"); var allow_creation = true;
	var new_name = ImGui.InputText("##label Asset Name", asset_create_name);
	var name_taken = false;
	for (var i = 0; i < instance_number(asset); i++) {
		var _inst = instance_find(asset, i);
			if new_name = _inst.name{
			name_taken = true;	
		}
	}
	if !name_taken {asset_create_name = new_name}else{ImGui.TextColored("**Duplicate name, cannot be used.", c_red, 1); allow_creation = false;}
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
	ImGui.PushItemWidth(ImGui.GetContentRegionMaxX()-20-ImGui.GetFrameHeight());
	asset_create_filepath = ImGui.InputText("##label File Path", asset_create_filepath); ImGui.SameLine();
	if (ImGui.ImageButton("File Picker Button", spr_file_icon, 0, c_white, 1, c_white, 0, ImGui.GetFrameHeight(), ImGui.GetFrameHeight())) {
		
		//Add a State Machine here that opens the file prompt with different filters for different asset types
		asset_create_filepath = get_open_filename_ext("Image Files|*.png;*.jpeg;*.jpg;*.gif;","", user_images, "Select Asset Image");
		
	}
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
} else {
	asset_create_name = "New Asset";
	var default_asset_name_str = "";
	var default_asset_count = 0;
	var default_name_match = true;
	while default_name_match {
		var default_match_found = false;
		for (var i = 0; i < instance_number(asset); i++) {
			var _inst = instance_find(asset, i);
			if _inst.name =  "New Asset" + default_asset_name_str {
				if default_asset_name_str = "" {
				default_asset_name_str = " " + string(default_asset_count);
				} else {
				default_asset_count++;
				default_asset_name_str = " " + string(default_asset_count);
				}
				default_match_found = true;
			}
		}
		if !default_match_found {default_name_match = false;}
	}
	asset_create_name = "New Asset" + default_asset_name_str;
}

//Saving
switch(zip_save_status) {

	//Save in Progress
	case "saving":
	var save_pos = new vec2(win_w  / 2, win_h / 2).Sub(save_offset);
	ImGui.SetNextWindowPos(save_pos.x, save_pos.y, ImGuiCond.Always);
	ImGui.Begin("Saving Scene", true, ImGuiWindowFlags.Modal | ImGuiWindowFlags.NoNav | ImGuiWindowFlags.NoDecoration | ImGuiWindowFlags.AlwaysAutoResize | ImGuiWindowFlags.NoMove);
	var warning_str = "Do not close program";
	var warning_offset = ImGui.CalcTextWidth(warning_str);
	//ImGui.SetCursorPosX((save_pos.x * 0.5)  - warning_offset);
	ImGui.Text(warning_str);
	save_offset = new vec2(ImGui.GetWindowWidth(), ImGui.GetWindowHeight()).Mul(0.5);
	ImGui.End();
	break;

	//Save Failed
	case "failed":
	var save_pos = new vec2(win_w  / 2, win_h / 2).Sub(save_offset);
	ImGui.SetNextWindowPos(save_pos.x, save_pos.y, ImGuiCond.Always);
	ImGui.Begin("Saving Failed", true, ImGuiWindowFlags.Modal | ImGuiWindowFlags.NoNav | ImGuiWindowFlags.NoDecoration | ImGuiWindowFlags.AlwaysAutoResize | ImGuiWindowFlags.NoMove);
	var warning_str = "Save Failed";
	var warning_offset = ImGui.CalcTextWidth(warning_str);
	//ImGui.SetCursorPosX((save_pos.x * 0.5)  - warning_offset);
	ImGui.Text(warning_str);
	if ImGui.Button("Okay") {zip_save_status = undefined;}
	save_offset = new vec2(ImGui.GetWindowWidth(), ImGui.GetWindowHeight()).Mul(0.5);
	ImGui.End();
	break;
	
}

}

#endregion