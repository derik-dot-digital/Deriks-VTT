#region File Association

//File Extension
var dm_file_ext = ".dvtt";
	
//Check for File Association flag
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
		
}
#endregion