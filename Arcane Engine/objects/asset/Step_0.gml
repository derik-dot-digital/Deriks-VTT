#region Load Asset

if file_path != undefined and file_requested = false {
	var new_path = working_directory+"assets\ "+name+file_extension;
	file_copy_ns(file_path, new_path);
	file_path = new_path;
	file_request_id = sprite_add_ext(file_path, 0, 0, 0, true);
	file_requested = true;
}

#endregion
#region Update

//Check Selection Status
if global.selected_inst = id {selected = true;}else{selected = false;}

#endregion