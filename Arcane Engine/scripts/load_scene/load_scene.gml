function load_scene(specific_directory = undefined, import_mode = false){

		//Select Scene .ZIP
		if specific_directory = undefined {
			dm.scene_directory = get_open_filename_ext("AE Scene File|*.zip;", "", default_scene_directory, "Select Arcane Engine Scene File");
		} else {
			dm.scene_directory = specific_directory;
		}
				
		//Reset some stuff to avoid crashes
		global.selected_inst = noone;
		
		//Check if fie exists
		if file_exists_ns(dm.scene_directory) {
			
			//ADD CHECKS FOR IF FILE IS VALID SCENE FILE 
			//IF NOT SHOW ERROR AND REMAIN ON SPLASH SCREEN
			//show_debug_message("fuck")
			
		//Clear Current Scene
		if !import_mode {clear_scene();}		
		
		//Get File Count (.ZIPs are unloaded to working directory)
		var file_count = zip_unzip(dm.scene_directory, working_directory);
		
		//Detect Scene Config 
		var found_config = file_find_first(working_directory + "/*scene_config.ini", fa_none);
		
		//Load & Apply Config
		if found_config != "" and !import_mode{ 

			//Open Config .INI
			ini_open(found_config);
		
			//Camera Data
			with (camera) {
			view_quat.x = ini_read_real("View Quat", "x", view_quat.x);
			view_quat.y = ini_read_real("View Quat", "y", view_quat.y);
			view_quat.z =  ini_read_real("View Quat", "z", view_quat.z);
			view_quat.w =  ini_read_real("View Quat", "w", view_quat.w);
			pos.x = ini_read_real("Camera Position", "x", pos.x);
			pos.y = ini_read_real("Camera Position", "y", pos.y);
			pos.z = ini_read_real("Camera Position", "z", pos.z);
			target.x = ini_read_real("Camera Target", "x", target.x);
			target.y = ini_read_real("Camera Target", "y", target.y);
			target.z = ini_read_real("Camera Target", "z", target.z);
			dir.x = ini_read_real("Camera Direction", "x", dir.x);
			dir.y = ini_read_real("Camera Direction", "y", dir.y);
			dir.z = ini_read_real("Camera Direction", "z", dir.z);
			up.x = ini_read_real("Camera Up", "x", up.x);
			up.y = ini_read_real("Camera Up", "y", up.y);
			up.z = ini_read_real("Camera Up", "z", up.z);
			fov = ini_read_real("Projection Settings", "fov", fov);
			znear_perspective = ini_read_real("Projection Settings", "znear_perspective", znear_perspective);
			znear_ortho = ini_read_real("Projection Settings", "znear_orthographic", znear_ortho);
			zfar = ini_read_real("Projection Settings", "zfar", zfar);
			projection_slider = ini_read_real("Projection Settings", "projection_slider", projection_slider);
			zoom = ini_read_real("Projection Settings", "zoom", zoom);
			zoom_strength = ini_read_real("Projection Settings", "zoom_strength", zoom_strength);	
			}
			
			//Grid Data
			with (grid) {
			grid.grid_size = ini_read_real("Grid Settings", "grid_size", grid.grid_size);
			grid.tile_size = ini_read_real("Grid Settings", "tile_size", grid.tile_size);
			grid.depth_mode = ini_read_string("Grid Settings", "depth_mode", grid.depth_mode);
			grid.color_mode = ini_read_real("Grid Settings", "color_mode", grid.color_mode);
			grid.grid_color.x = ini_read_real("Grid Settings", "grid_color_red", grid.grid_color.x);
			grid.grid_color.y = ini_read_real("Grid Settings", "grid_color_green", grid.grid_color.y);
			grid.grid_color.z = ini_read_real("Grid Settings", "grid_color_blue", grid.grid_color.z);
			grid.grid_color.w = ini_read_real("Grid Settings", "grid_color_alpha", grid.grid_color.w);
			grid.rainbow_color_scale = ini_read_real("Grid Settings", "rainbow_color_scale", grid.rainbow_color_scale);
			grid.rainbow_color_spd = ini_read_real("Grid Settings", "rainbow_color_spd", grid.rainbow_color_spd);
			}
			
			//Close .INI
			ini_close();
			
		}
		
		//Detect Assets
		var found_file = file_find_first(working_directory + "assets/*.ini", fa_none);
		
		//Set Scene name & Directory
		dm.scene_name = filename_name(dm.scene_directory); //Remove Directory
		dm.scene_directory = string_replace(dm.scene_directory, dm.scene_name, ""); //Remove .ZIP name from the path chosen earlier
		dm.scene_name = string_replace(dm.scene_name, ".zip", ""); //Remove file extension
		
		//Store Found .INI files in list
		while (found_file != "")
		{
			ds_list_add(dm.asset_list, working_directory + "assets/" + found_file);
			found_file = file_find_next();
		}
		
		//Close out file search
		file_find_close();
				 
		//Spawn Assets
		for (var i = 0; i < ds_list_size(dm.asset_list); i++) {
			
			//Store Current .INI path
			var current_ini = ds_list_find_value(dm.asset_list, i)
			
			//Open Asset .INI
			ini_open(current_ini);
			
			//Spawn Instance
			var asset_inst = instance_create_depth(0, 0, 0, asset);
			
			//Load Data & Apply to Instance
			asset_inst.name = ini_read_string("Data", "name", "undefined");
			asset_inst.type = ini_read_real("Data", "type", 0);
			asset_inst.file_path = ini_read_string("Data", "path", "undefined");
			asset_inst.file_extension = str_check_compatable_file_type(asset_inst.file_path);
			asset_inst.pos.x = ini_read_real("Position", "x", 0);
			asset_inst.pos.y = ini_read_real("Position", "y", 0);
			asset_inst.pos.z = ini_read_real("Position", "z", 0);
			asset_inst.scale.x = ini_read_real("Scale", "x", 1);
			asset_inst.scale.y = ini_read_real("Scale", "y", 1);
			asset_inst.scale.z = ini_read_real("Scale", "z", 1);
			asset_inst.orientation.x = ini_read_real("Orientation", "x", 0);
			asset_inst.orientation.y = ini_read_real("Orientation", "y", 0);
			asset_inst.orientation.z = ini_read_real("Orientation", "z", 0);
			asset_inst.orientation.w = ini_read_real("Orientation", "w", 1);
		
			//Close .INI
			ini_close();
				
		}
			
		//Fresh .ZIP for session
		dm.scene_zip = zip_create();
		
		//Reset Scene Creation Settings (Incase they were changed before loading)
		camera.scene_create_name = "New Scene";
		camera.scene_create_directory = "Copy file path here!";
		
		//Exit Splash Window
		camera.splash_window = false;
	
	}
			
}