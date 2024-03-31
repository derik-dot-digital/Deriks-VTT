#region Load Asset
if file_path != undefined and file_requested = false {
	file_request_id = sprite_add_ext(file_path, 0, 0, 0, true);
	file_requested = true;
}