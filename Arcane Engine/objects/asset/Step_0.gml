#region Update

//Load Image into Working Directory
if file_path != undefined and file_requested = false {

	//New File Path in Asset Directory
	var new_path = asset_directory+name+file_extension;
	
	//Ensure Asset Directory has been created
	if !directory_exists_ns(asset_directory) {directory_create(asset_directory);}
	
	//Copy Source File into Directory
	file_copy_ns(file_path, new_path);
	
	//Update FIle Path
	file_path = new_path;
	
	//Load the Image
	file_request_id = sprite_add_ext(file_path, 0, 0, 0, true);
	
	//Show the image has been requested to avoid repeat loads
	file_requested = true;
	
}

//Ensure Continuity of File Name with Asset Name
if file_loaded {
	var current_file_name = filename_name(file_path);
	if current_file_name != name+file_extension {

		//New File Path with New FIle Name
		var new_path = asset_directory+name+file_extension;
	
		//Rename File
		file_rename_ns(file_path, new_path);
	
		//Update File Path
		file_path = new_path;
	
	}
}

//Check Selection Status
if global.selected_inst = id {selected = true;}else{selected = false;}

#endregion