#region Input

//Update Mouse Position
mouse_pos = new vec2(mouse_x, mouse_y);

//Distance from previous Mouse Position
var mouse_dx = mouse_pos.x - mouse_pos_prev.x;
var mouse_dy = mouse_pos.y - mouse_pos_prev.y;
var mouse_delta = new vec2(mouse_dx, mouse_dy);

//Scroll Wheel Input
var mouse_scroll = -mouse_wheel_up()+mouse_wheel_down();

//Middle Mouse Actions
if mouse_check_button(mb_middle) {

	//Orbital Pan
	if mouse_delta.Magnitude() != 0 {
		var xrot_quat = new quat().FromAngleAxis(-mouse_delta.x * 0.003, world_up).Normalize();
		var yrot_quat = new quat().FromAngleAxis(mouse_delta.y * 0.003, world_x).Normalize();
		view_quat = xrot_quat.Mul(view_quat).Normalize();
		view_quat = view_quat.Mul(yrot_quat).Normalize();
		//dir = view_quat.ToAngleAxis();
	}
}

//Scroll Wheel Actions
if mouse_scroll != 0 {
	
	//Zoom
	zoom *= power(zoom, mouse_scroll*zoom_strength);
}

//Update Mouse Previous Position
mouse_pos_prev = mouse_pos;

//Clamp Zoom
zoom = max(zoom, 0.1);

#endregion
#region Camera

pos = target.Add(dir.Mul(zoom));
right = up.Cross(dir).Normalize();
up = dir.Cross(right).Normalize();

//Clamp Settings
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

	}
	ImGui.EndMenu();
}

//Camera Settings
if camera_settings_open {	

	//Close Window
	var ret = ImGui.Begin("Camera Settings", camera_settings_open, ImGuiWindowFlags.AlwaysAutoResize, ImGuiReturnMask.Both);
	camera_settings_open = ret & ImGuiReturnMask.Pointer;

	//View Quaternion
	var view_quat_array = view_quat.AsLinearArray();
	ImGui.InputFloat4("View Quaternion  (Read Only)", view_quat_array,,,,ImGuiInputTextFlags.ReadOnly);
	
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
	
	//Zoom
	zoom = ImGui.InputFloat("Zoom", zoom, 1, 5);
	
	//Zoom Strength
	zoom_strength = ImGui.InputFloat("Zoom Strength", zoom_strength, 0.005,  0.005);
	
	ImGui.End();

}

#endregion
