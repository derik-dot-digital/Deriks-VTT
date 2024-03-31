if !file_loaded {
	var loaded_data = async_load[?"id"];
	if (loaded_data == file_request_id)
	{
	    art = loaded_data;
		file_loaded = true;
	}
}