#region Save Object Data to .ZIP

//Save Sprite 
zip_add_file(dm.scene_zip, "assets/"+name+file_extension, "assets/"+ name + ".png"); //PNG Workaround for save_sprite

//Save Data
ini_open("assets/"+name+".ini");
ini_write_string("Data", "name", name);
ini_write_real("Data", "type", type);
ini_write_string("Data", "path", "assets/"+name+file_extension);
ini_write_real("Position", "x", pos.x);
ini_write_real("Position", "y", pos.y);
ini_write_real("Position", "z", pos.z);
ini_write_real("Orientation", "x", orientation.x);
ini_write_real("Orientation", "y", orientation.y);
ini_write_real("Orientation", "z", orientation.z);
ini_write_real("Orientation", "w", orientation.w);
ini_close();
zip_add_file(dm.scene_zip, "assets/"+name+".ini", "assets/"+ name+".ini")

#endregion