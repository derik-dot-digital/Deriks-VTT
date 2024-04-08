if !file_loaded {
	var loaded_data = async_load[?"id"];
	if (loaded_data == file_request_id)
	{
	    art = loaded_data;
		art_w = sprite_get_width(art);
		art_h = sprite_get_height(art);
		file_loaded = true;
	}
}