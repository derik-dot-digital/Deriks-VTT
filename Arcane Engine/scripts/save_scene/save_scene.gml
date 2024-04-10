function save_scene(){
	
		//Save Scene Config
		with(camera) {event_user(0);}
		
		//Add Assets to .ZIP
		with(asset) {event_user(0);}

		//Save .ZIP
		with (camera) {
		zip_save_id = zip_save(dm.scene_zip, dm.scene_directory + dm.scene_name + ".zip")
		
		//Update .ZIP Saving Status
		zip_save_status = "saving";
		}
}