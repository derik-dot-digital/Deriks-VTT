// Check to see what kind of event happened
var eventType = ds_map_find_value(async_load,"event_type");

// If a file was dropped over the window
if eventType == "file_drop"
    {
		with (camera) {
			
		//Open Asset Creation
		create_asset_open = true;
		
		//Pass Info into GUI
		asset_create_filepath = ds_map_find_value(async_load,"filename");
		asset_create_name = string_replace(string(filename_name(asset_create_filepath)), string(filename_ext(asset_create_filepath)), "");
		
		}
    }