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

#endregion
#region Camera

//Middle Mouse Actions
if mouse_check_button(mb_middle) {

	//Orbital Pan
	if mouse_delta.Magnitude() != 0 {
		var xrot_quat = new quat().FromAngleAxis(-mouse_delta.x * 0.003, world_up).Normalize();
		var yrot_quat = new quat().FromAngleAxis(mouse_delta.y  * 0.003, world_x).Normalize();
		view_quat = xrot_quat.Mul(view_quat).Normalize();
		view_quat = view_quat.Mul(yrot_quat).Normalize();
		dir = world_up.RotatebyQuat(view_quat).Normalize();
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

//Update Position
pos = target.Add(dir.Mul(-zoom));

//Update Vectors
right = up.Cross(dir).Normalize();
up = dir.Cross(right).Normalize();

//Clamp Zoom Values
zoom = max(zoom, 0.1);
zoom_strength = max(zoom_strength, 0.001);

#endregion
#region ImGUI

//Tool Bar
ImGui.BeginMainMenuBar();
if (ImGui.BeginMenu("Options")) {
	if (ImGui.MenuItem("Camera Settings")) {
		if !camera_settings_open {camera_settings_open = true;}
	}
	if (ImGui.MenuItem("Grid Settings")) {
		if !grid_settings_open {grid_settings_open = true;}
	}
	ImGui.EndMenu();
}

//Camera Settings
if camera_settings_open {	

	//Close Window
	var ret = ImGui.Begin("Camera Settings", camera_settings_open, ImGuiWindowFlags.AlwaysAutoResize, ImGuiReturnMask.Both);
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
	
	//Projection Slider
	projection_slider = ImGui.SliderFloat("Projection Type", projection_slider, 0, 1);
	
	//Zoom
	zoom = ImGui.InputFloat("Zoom", zoom, 1, 5);
	
	//Zoom Strength
	zoom_strength = ImGui.InputFloat("Zoom Strength", zoom_strength, 0.005,  0.005);
	
	//End Menu
	ImGui.End();

}

//Grid Settings
if grid_settings_open {	

	//Setting Updated
	var regenerate_buffer = 0;
	
	//Close Window
	var ret = ImGui.Begin("Grid Settings", grid_settings_open, ImGuiWindowFlags.AlwaysAutoResize, ImGuiReturnMask.Both);
	grid_settings_open = ret & ImGuiReturnMask.Pointer;

	//Tile size
	var prev_grid_size = grid.grid_size;
	grid.grid_size = ImGui.InputInt("Grid Size", grid.grid_size, 1, 10);
	if grid.grid_size != prev_grid_size {regenerate_buffer = 1;}
	
	//Tile size
	var prev_tile_size = grid.tile_size;
	grid.tile_size = ImGui.InputInt("Tile Size", grid.tile_size, 1, 10);
	if grid.tile_size != prev_tile_size {regenerate_buffer = 1;}

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
	}
	
	//Rainbow Color Speed
	if grid.color_mode = grid_color_mode.rainbow_solid or grid.color_mode = grid_color_mode.rainbow_wave {
		grid.rainbow_color_spd = ImGui.InputFloat("Rainbow Speed", grid.rainbow_color_spd, 0.01, 0.1);
	}

	//Rainbow Color Scale
	if  grid.color_mode = grid_color_mode.rainbow_wave {
		grid.rainbow_color_scale = ImGui.InputFloat("Rainbow Scale", grid.rainbow_color_scale, 0.001, 0.01);
	}
	
	//Force vBuffer regeneration
	if regenerate_buffer {with(grid) {update_grid();}}
	
	//End Menu
	ImGui.End();
	
}


#endregion