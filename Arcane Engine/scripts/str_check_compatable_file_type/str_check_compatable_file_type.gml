//Add Checks for Compatable File Extensions Here
function str_check_compatable_file_type(file_path_str) {
	var res = undefined;
	if string_ends_with(file_path_str, ".png")	{res = ".png";}
	if string_ends_with(file_path_str, ".jpg")	{res = ".jpg";}
	if string_ends_with(file_path_str, ".jpeg")	{res = ".jpeg";}		
	return res;
}