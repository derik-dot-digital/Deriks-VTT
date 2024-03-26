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
		var xrot_quat = new quat().FromAngleAxis(-mouse_delta.x * 0.01, up).Normalize();
		pos = xrot_quat.TransformVec3(pos.Sub(target)).Add(target);
		var yrot_quat = new quat().FromAngleAxis(-mouse_delta.y * 0.01, right).Normalize();
		pos = yrot_quat.TransformVec3(pos.Sub(target)).Add(target);
	}
}


//Update Mouse Previous Position
mouse_pos_prev = mouse_pos;

#endregion
#region Camera

var mag  = pos.Sub(target).Magnitude();
var new_dir = pos.Sub(target).Normalize();
pos = target.Add(new_dir.Mul(zoom));

dir = pos.Sub(target).Normalize();
right = up.Cross(dir).Normalize();
up = dir.Cross(right).Normalize();


	
view_quat = new quat().FromLookRotation(dir, up).Normalize();

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

