#region Initialize Game

//Spawn Controller Objects
instance_create_depth(0, 0, 0, camera);
instance_create_depth(0, 0, 0, grid);
instance_create_depth(0, 0, 0, skybox);

//Enable Drag n' Drop
file_dropper_init();

//Store file path to detect if game opened with a save file
associated_file_path = undefined;

#endregion
#region Assets

//Asset Types
enum asset_types {
	empty,
	map,
	art,
	player,
	npc,
}

//Asset Actions
enum asset_actions {
	idle,
	move,
	rotate,
	scale
}

//Selected Inst ID
global.selected_inst = noone;

//Selection Action
global.selection_action = asset_actions.idle;

//Outline Size
global.outline_size = 0.001;

#endregion
#region Colmesh

//Store a Global Array of Texcoords for a flat image
global.texcoords = [new vec2(0, 0), new vec2(0, 1), new vec2(1, 0), new vec2(1, 1)]

//Store active collision shapes
global.collision = cm_list();

#endregion
#region Scene Management

//Store if scene has been saved
scene_saved = false;

//Scene Name
scene_name = undefined;

//Directory
scene_directory = undefined;

//Scene ZIP
scene_zip = undefined;

//Asset List used for saving/loading
asset_list = ds_list_create();

#endregion
#region File Association

//File Extension
var dm_file_ext = ".dvtt";
	
//Check for File Association flag to determine wether or not to run the script
var file_association_flag_path = program_directory + "file_association_flag" + dm_file_ext;
var file_association_flag = file_exists_ns(file_association_flag_path);
if !file_association_flag 
{
	
	//Icon Path
	var dvtt_icon_path = program_directory + "dvtt_icon.ico";

	//Program ID
	var dvtt_prog_id = "DeriksVTT";

	//File Type Description
	var dvtt_file_type_desc = "Deriks VTT File";

	//File Perceived Type
	var dvtt_perceived_type = "document";

	//Run File Association Script
	gm_file_association(dm_file_ext, dvtt_icon_path, dvtt_prog_id, dvtt_file_type_desc, dvtt_perceived_type, true, false)
	
}
else
{
	
	//Check if file association files exist and delete them as they are no longer needed
	var game_path = program_directory;
	var refresh_icons_path = game_path + "RefreshIcons.ps1";
	var file_assoc_path = game_path + "file_assoc.bat";
	if file_exists_ns(refresh_icons_path) {
		file_delete_ns(refresh_icons_path);	
	}
	if file_exists_ns(file_assoc_path) {
		file_delete_ns(file_assoc_path);	
	}
	
	//Check if program was opened with a save file
	for (var i = 0; i < parameter_count(); i ++) { 
		var param = parameter_string(i);
		show_message(param);
		if string_count(dm_file_ext, param) > 0 {
			associated_file_path = param;
			show_message(associated_file_path);
		}
	}
}

//Trigger loading the associated file
if associated_file_path != undefined {
	load_scene(associated_file_path);
	associated_file_path = undefined;

}

#endregion