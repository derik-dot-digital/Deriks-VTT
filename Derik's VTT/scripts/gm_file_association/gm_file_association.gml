#region README

/////////////////////////////////////////////////////////////////////////////////////////////
//								          		Gamemaker File Association						            //									
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
/// @param {string} prog_id 
/// @param {string} file_type_desc
/// @param {string} perceived_type
/// @param {bool} force_refresh
/// @param {bool} debug
function gm_file_association(argument0, argument1, argument2, argument3, argument4, argument5 = false, argument6 = true)
{

	//Store Arguments
	var file_ext = argument0;
	var icon_path = argument1;
	var prog_id = argument2;
	var file_type_desc = argument3;
	var perceived_type = argument4; //https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/cc144150(v=vs.85)
	var force_refresh = argument5;
	var debug = argument6;

	//Make sure requirements are met
	var requirements_met = true;
	if requirements_met = true {

		//Make sure input is a string
		if !is_string(file_ext) or !is_string(icon_path) {
			show_message("GM Custom File Association failed. Script input must be a valid string.");	
			requirements_met = false;
		}

		//Store File Extension without dot
		var file_ext_without_dot = string_replace(file_ext, ".", "");

		//Ensures extensions are present
		if !extension_exists("libfilesystem"){
			show_message("GM Custom File Association failed. Missing FileManger extension.");	
			requirements_met = false;
		}
		if !extension_exists("execute_shell_simple_ext")  {
			show_message("GM Custom File Association failed. Missing execute_shell_simple_ext extension.");	
			requirements_met = false;
		}

		//Ensure OS is Windows
		if os_type != os_windows {
			show_message("GM Custom File Association failed; only supports Windows.");	
			requirements_met = false;
		}

		//Ensure valid File Extension
		if file_ext != undefined {

		//Ensure a single dot is used
		if string_count(".", file_ext) != 1 {
			show_message("GM Custom File Association failed. Cannot use a file extension with more than one dot.");	
			requirements_met = false;
		}	
	
		//Force alphanumeric extensions to avoid issues
		for(var i = 1; i <= string_length(file_ext_without_dot); ++i) {
			if string_pos(string_char_at(file_ext_without_dot, i), "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") == 0 {
				show_message("GM Custom File Association failed. File extension must be alphanumeric after the dot");	
				requirements_met = false;
				break;
			}
		}
		
		}
		
		//Ensure valid Icon 
		if !string_ends_with(icon_path, ".ico") {
			show_message("GM Custom File Association failed; Not a valid icon file.");	
			requirements_met = false;
		}
	}
	
	//Checks if game has been compiled and is not being run from inside Gamemaker's IDE. (Debug mode forces it to run regardless of checks)
	if (requirements_met) {
		
		//Returns the .exe path
		var app_path = parameter_string(0);
		
		//New Line
		var nl = chr(13) + chr(10);
		
		//Quotation Mark
		var quote = chr(34);
		
		//Horizontal Indentation
		var indent = chr(9);
		
		//Store game file path
		var game_path = program_directory;
		
		//Store the path to the force refresh PowerShell script
		var force_refresh_path = game_path + "RefreshIcons.ps1";
				
		//Store the path to the file association batch file
		var file_assoc_path = game_path + "file_assoc.bat";
		
		//Generate .ps1 Powershell Script to force Windows icon cache refresh		
		if force_refresh {
			var _ps1 = "";
			_ps1 += @"Add-Type -TypeDefinition @" + quote;
			_ps1 += nl + @"using System;";
			_ps1 += nl + @"using System.Runtime.InteropServices;";
			_ps1 += nl + @"";
			_ps1 += nl + @"public static class ShellUpdates {";
			_ps1 += nl + indent + @"[DllImport(" + quote + @"shell32.dll" + quote + @", CharSet = CharSet.Auto)]";
			_ps1 += nl + indent + @"public static extern void SHChangeNotify(int wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);";
			_ps1 += nl + @"";
			_ps1 += nl + indent + @"public const int SHCNE_ASSOCCHANGED = 0x08000000;";
			_ps1 += nl + indent + @"public const uint SHCNF_IDLIST = 0x0000;";
			_ps1 += nl + @"}";
			_ps1 += nl + quote + "@";
			_ps1 += nl + @"";
			_ps1 += nl + "[ShellUpdates]::SHChangeNotify([ShellUpdates]::SHCNE_ASSOCCHANGED, [ShellUpdates]::SHCNF_IDLIST, [System.IntPtr]::Zero, [System.IntPtr]::Zero)";
			_ps1 += nl + @"";
		
			//Save Powershell Script
			string_save_ns(_ps1, force_refresh_path);		
			
			//Saves to desktop for inspection (replace path with whatever you want, I was using an extension to get the desktop directory
			//string_save_ns(_ps1, directory_get_desktop_path()+"generated_ps1.ps1");
			
		}
		
		//Format App Path for PowerShell
		var ps_app_path = string_replace_all(app_path, "\\", "\\\\");
		ps_app_path = string_replace_all(ps_app_path, "'", "''");
		
		//Extract and format Process Name from App Path for PowerShell
		var ps_get_process = string_replace(filename_name(ps_app_path), ".exe", "");
		
		//Generate .bat to update registry
		var _bat = "";
		_bat += "@echo off";
		_bat += nl + @"SETLOCAL";
		_bat += nl + @"";
		_bat += nl + @":: Checking for administrative privileges";
		_bat += nl + @"net session >nul 2>&1";
		_bat += nl + @"if %errorlevel% == 0 (";
		_bat += nl + indent + @"echo Running with administrative rights";
		_bat += nl + @") else (";
		_bat += nl + indent + @"echo Kill current process and re-launch requesting administrative rights...";
		_bat += nl + indent + @"powershell -ExecutionPolicy Bypass -Command " + quote + "Get-Process '" + ps_get_process + "' -ErrorAction SilentlyContinue | Stop-Process -Force" + quote;
		_bat += nl + indent + @"powershell -ExecutionPolicy Bypass -Command " + quote + @"Start-Process '" + ps_app_path + @"' -Verb RunAs" + quote;
		_bat += nl + indent + @"exit /b";
		_bat += nl + @")";
		_bat += nl + @"";
		_bat += nl + @":: Path to your application";
		_bat += nl + @"set " + quote + "APP_PATH=" + app_path + quote;
		_bat += nl + @"";
		_bat += nl + @":: Path to your icon";
		_bat += nl + @"set " + quote + "ICON_PATH=" + icon_path + quote;
		_bat += nl + @"";
		_bat += nl + @":: Register the file extension";
		_bat += nl + @"reg add HKCR\" + file_ext + " /ve /d " + quote + prog_id + quote + " /f";
		_bat += nl + @"";
		_bat += nl + @":: Define the file type";
		_bat += nl + @"reg add HKCR\" + prog_id + " /ve /d " + quote + file_type_desc + quote + " /f";
		_bat += nl + @"";
		_bat += nl + @":: Associate icon";
		_bat += nl + @"reg add HKCR\" + prog_id + @"\DefaultIcon /ve /d " + quote + "%ICON_PATH%" + quote + " /f"
		_bat += nl + @"";
		_bat += nl + @":: Set the command to open the file with your application";
		_bat += nl + @"reg add HKCR\" + prog_id + @"\shell\open\command /ve /d " + quote + "\\" + quote + "%APP_PATH%" + "\\" + quote + " \\" + quote + "%1" + "\\" + quote + quote + " /f";
		_bat += nl + @"";
		_bat += nl + @":: Set content type and perceived type";
		_bat += nl + @"reg add HKCR\" + prog_id + " /v " + quote + "Content Type" + quote + " /d " + quote + "application/vnd" + file_ext + quote + " /f";
		_bat += nl + @"reg add HKCR\" + prog_id + " /v " + quote + "PerceivedType" + quote + " /d " + quote + perceived_type + quote + " /f";
		_bat += nl + @"";
		_bat += nl + @":: Add PersistentHandler";
		_bat += nl + @"reg add HKCR\" + file_ext + @"\PersistentHandler /ve /d " + quote + "{5e941d80-bf96-11cd-b579-08002b30bfeb}" + quote + " /f";
		_bat += nl + @"";
		if force_refresh {
		_bat += nl + @"";
		_bat += nl + @":: Call PowerShell script to refresh icons";
		_bat += nl + @"powershell -ExecutionPolicy Bypass -File " + quote + force_refresh_path + quote;
		_bat += nl + @"";
		}
		_bat += nl + @":: Create a flag file to indicate successful setup";
		_bat += nl + @"echo File associations configured successfully. > " + quote + game_path + @"file_association_flag" + file_ext + quote;
		_bat += nl + @"";
		_bat += nl + @"ENDLOCAL";
		_bat += nl + @"echo File association, icon setup, and command handling complete.";
		_bat += nl + @"pause";
	
	//Save Batch File
	string_save_ns(_bat, file_assoc_path);
	
	//Saves to desktop for inspection (replace path with whatever you want, I was using an extension to get the desktop directory
	//string_save_ns(_bat, directory_get_desktop_path()+"generated_bat.bat"); 

	//Run Generated files
	var show_cmd = 0;
	if debug {show_cmd = 5;} //value that shows cmd per the Yal's documentation;
	execute_shell_simple(file_assoc_path,,,show_cmd);
	
	}
	
}