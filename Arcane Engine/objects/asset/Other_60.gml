if !file_loaded {
	var loaded_data = async_load[?"id"];
	if (loaded_data == file_request_id)
	{
	    art = loaded_data;
		art_w = sprite_get_width(art);
		art_h = sprite_get_height(art);
		file_loaded = true;
		var ref =sprite_duplicate(art); //Workaround for a dynamic reference to give sprite_save
		sprite_save(ref, 0, "assets/"+ name+".png");
		sprite_delete(ref);
	}
}