function save_scene(){
	
	//Save Scene Config
	with(camera) {event_user(0);}
		
	//Add Assets to .ZIP
	with(asset) {event_user(0);}

	//Save .ZIP
	with (camera) {
			
	//.ZIP Path
	var save_directory = dm.scene_directory + dm.scene_name + ".zip";
		
	//Delete old save file to avoid corruption from overwritting
	if file_exists_ns(save_directory) {file_delete_ns(save_directory);}
	zip_save_id = zip_save(dm.scene_zip, save_directory);
		
	//Fresh .ZIP
	dm.scene_zip = zip_create();
		
	//Update .ZIP Saving Status
	zip_save_status = "saving";
		
	}
}