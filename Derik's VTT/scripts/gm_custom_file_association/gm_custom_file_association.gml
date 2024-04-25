#region README

/////////////////////////////////////////////////////////////////////////////////////////////
//									Gamemaker Custom File Association						        //									
////////////////////////////////////////////////////////////////////////////////////////////
//		--------------------------------------------CREDITS------------------------------------------------
//		Asset made by Derik.NET
//		https://github.com/derik-dot-net
//
//		Inspired by Juju Adam's Furballs
//		https://jujuadams.itch.io/furballs
//
//		Based on Microsoft's documention
//		https://learn.microsoft.com/en-us/windows/win32/shell/fa-intro
//
//		-----------------------------------WHAT DOES THIS DO?------------------------------------
//		This asset allows the developer to use Gamemaker to associate files
//		such as save-files with their program. So that the end-user can then 
//		click on the file to automatically open the program, which could then
//		immediately load the save file if wanted. Furthmore this asset allows 
//		an icon to be set for those files. 
//
//		It does this by defining your custom file extension in Windows just as
//		programs such as Gamemaker or Blender do for .proj files and .blend
//		files respectively. As part of this process it defines the file extension,
//		the associated .exe file path, and the associated .ico file path. Once
//		those changes are applied a script runs that forces a refresh for
//		Window's icon cache so the changes are immediately viewable.
//
//		---------------------------------USE AT YOUR OWN RISK-----------------------------------
//		This extensions edits the registry of the users windows installation to 
//		associate a specified file extension with the program, and also allows
//		for a custom icon to be specified for files with that extension.
//
//		Make sure the file extension and program name is one that will most-
//		likely not ever be present on an end-users machine. Microsoft
//		recommends checking this page:
//		https://www.iana.org/assignments/media-types/media-types.xhtml
//		I'd also recomend googling your file extension to verify its uniqueness.
//
//		Files that use the same extension will all become associated with your 
//		program and if one is defined the icon for those files will also all change. 
//		If this is used incorrectly, a user or end-user could experience major
//		issues with their computer. Especially if an important file extension
//		was modified using this code.
//
//		This is also not guarenteed to work, as I do not claim to be an expert
//		on manipulating Windows or the the registry, but I did my best to 
//		follow the instructions provided by Microsoft, as well as replicate the
//		shared structure of other file extensions defined in the registry.
//
//		----------------------------------------REQUIREMENTS----------------------------------------
//		This asset requires the following extension for Gamemaker to be
//		included to the Gamemaker project in order for it to work.
//
//		execute_shell_simple for Gamemaker by YellowAfterLife
//		https://yellowafterlife.itch.io/gamemaker-execute-shell-simple
//		This extension is what allows this asset  to run the .bat file from
//		within Gamemaker during runtime. 
//
//		---------------------------------------NOTES ON USAGE--------------------------------------
//		This asset as provided does not do file association unless the game is
//		compiled. This is because when you run your game inside of the IDE 
//		while developing it within Gamemaker, it is run in special enviorment
//		using Gamemaker's runner.exe, which unless compiled is what the 
//		function program_pathname will return. If this wasn't the case your
//		file extension could become associated with Gamemaker's runner.
//
//		I also DO NOT recommend putting the script call anywhere that it 
//		could be run multiple times, you likely never would want to do that.
//
//		If your program is still early in the development or you are a new user 
//		to gamemaker then this asset is NOT FOR YOU.
//
//		If you think its possible the file extension you plan to use may change
//		then please read the USE AT YOUR OWN RISK section above. 
//
//		I would make sure that you are happy with both your file extension of
//		choice, as well as your icon, because making multiple changes to the
//		registry is probably not good practice.
//
//		If you want to view the changes made to the registry by this asset after
//		it has been run, then press WIN + R and then type in regedit and press
//		ok. This should open the Registry Editor, where you you should be able
//		to find the added registry keys under HKEY_CLASSES_ROOT. If you need 
//		to debug this is where you should look.
//
//		This asset  only accepts a file path to a valid .ico icon image.
//		It is recommended that whatever image you are trying to use, you
//		store it in the included files and determine the path programmatically
//		rather than hardcoding it.
//		for example: 
//		var icon_path = working_directory + "icon_name.ico"; 
//
//		If you have an image and don't know how to convert it to an icon,
//		I recommend using this website: https://convertico.com/
//
/////////////////////////////////////////////////////////////////////////////////////////////

#endregion

/// @param {string} file_extension
/// @param {string} icon_path
function gm_custom_file_association(argument0, argument1)
{

//Store Arguments
var file_ext = argument0;
var icon_path = argument1;

//Make sure requirements are met
var requirements_met = true;
if requirements_met = true {

	//Make sure input is a string
	if !is_string(file_ext) or !is_string(icon_path) {
	show_debug_message("GM Custom File Association failed. Script input must be a valid string.");	
	requirements_met = false;
	}

	//Store File Extension without dot
	var file_ext_without_dot = string_replace(file_ext, ".", "");

	//Ensures extensions are present
	if !extension_exists("libfilesystem"){
	show_debug_message("GM Custom File Association failed. Missing FileManger extension.");	
	requirements_met = false;
	}
	if !extension_exists("execute_shell_simple_ext")  {
	show_debug_message("GM Custom File Association failed. Missing execute_shell_simple_ext extension.");	
	requirements_met = false;
	}

	//Ensure OS is Windows
	if os_type != os_windows {
	show_debug_message("GM Custom File Association failed; only supports Windows.");	
	requirements_met = false;
	}

	//Ensure valid File Extension
	if file_ext != undefined {

	//Ensure a single dot is used
	if string_count(file_ext, ".") != 1 {
		show_debug_message("GM Custom File Association failed. Cannot use a file extension with more than one dot.");	
		requirements_met = false;
	}	
	
	//Force alphanumeric extensions to avoid issues
	for(var i = 1; i <= string_length(file_ext_without_dot); ++i) {
		if string_pos(string_char_at(file_ext_without_dot, i), "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") == 0 {
			show_debug_message("GM Custom File Association failed. File extension must be alphanumeric after the dot");	
			requirements_met = false;
			break;
		}
	}
		
	}
		
	//Ensure valid Icon 
	if !string_ends_with(icon_path, ".ico") {
	show_debug_message("GM Custom File Association failed; Not a valid icon file.");	
	requirements_met = false;
	}
}
	
	//Checks if game has been compiled and is not being run from inside Gamemaker's IDE.
	if code_is_compiled()  & requirements_met {
		
		//Store New Line for String Insertion
		var nl = chr(13)+chr(10);

		//Returns the .exe path
		var app_path = parameter_string(0);
		
		//Store .bat string
		var _bat = "";
		_bat += "@echo off" + nl;
		_bat += "SETLOCAL" + nl;
		_bat += nl;
		_bat += ":: Path to your application" + nl;
		_bat += "set APP_PATH="+file_ext+nl;
		_bat += nl;
		_bat += ":: Path to your icon" + nl;
		_bat += "set ICON_PATH="+icon_path;
		
	}

}