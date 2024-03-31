//Add Checks for Compatable File Extensions Here
function str_check_compatable_file_type(file_path_str) {
	return max(	string_ends_with(file_path_str, ".png"), 
							string_ends_with(file_path_str, ".jpg"), 
							string_ends_with(file_path_str, ".jpeg"));
}