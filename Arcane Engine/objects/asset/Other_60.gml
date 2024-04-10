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
		
	}
}