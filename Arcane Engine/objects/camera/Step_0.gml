#region Input

//Update Mouse Position
mouse_pos = new vec2(mouse_x, mouse_y);

//Distance from previous Mouse Position
var mouse_dx = mouse_pos.x - mouse_pos_prev.x;
var mouse_dy = mouse_pos.y - mouse_pos_prev.y;
var mouse_delta = new vec2(mouse_dx, mouse_dy);

//Reset Orientation
orientation = new quat();

//Middle Mouse Actions
if mouse_check_button(mb_middle) {
	
	//Store Current Action
	var action = undefined;

	//Orbital Pan
	if mouse_delta.Magnitude() != 0 {


	}
}


//Update Mouse Previous Position
mouse_pos_prev = mouse_pos;

#endregion
#region Camera

#endregion
#region ImGUI

ImGui.BeginMainMenuBar();
if (ImGui.BeginMenu("Options")) {
	if (ImGui.MenuItem("Camera Settings")) {

	}
	if (ImGui.MenuItem("Grid Settings")) {

	}
	ImGui.EndMenu();
}

#endregion