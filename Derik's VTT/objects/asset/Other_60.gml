//Check if Sprite has been loaded
if !file_loaded {
	
	//Retreive Data
	var loaded_data = async_load[?"id"];
	
	//Data Received
	if (loaded_data == file_request_id)
	{
		
		//Store Newly Loaded Sprite
	    art = loaded_data;
		
		//Show that the Sprite is Loaded
		file_loaded = true;
		
		//Update Image Size
		if sprite_exists(art) {
		
			//Only update resolution if custom one isn't already loaded in
			if !loaded_from_save {
				
				//Store Sprite Size
				art_w = sprite_get_width(art);
				art_h = sprite_get_height(art);
				
			}
		}
	}
}