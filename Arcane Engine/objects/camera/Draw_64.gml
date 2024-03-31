var sw = surface_get_width(application_surface);
var sh = surface_get_height(application_surface);
if display_get_gui_width() != sw or display_get_height() != sh {
	display_set_gui_size(sw, sh);	
}
ImGui.__Render();