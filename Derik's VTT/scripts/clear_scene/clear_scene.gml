function clear_scene(){
	
			//Clear Scene Config
			var scene_config_dir = working_dir+"scene_config.ini";
			if file_exists_ns(scene_config_dir) {
			file_delete_ns(scene_config_dir);
			}	
				
			//Clear Asset Directory
			if directory_exists_ns(asset_directory) {
			directory_delete_ns(asset_directory);
			}
				
			//Clear Asset List
			ds_list_clear(dm.asset_list)
			
			//Clear .ZIP reference
			dm.scene_zip = undefined;
			
			//Clear Any Pre-Existing Assets from Scene
			with (asset) {instance_destroy();}
			
			//Reset Grid & Skybox
			instance_destroy(grid); instance_create_depth(0, 0, 0, grid);
			instance_destroy(skybox); instance_create_depth(0, 0, 0, skybox);
			
}