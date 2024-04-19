#region Save Object Data to .ZIP

//Save Sprite 
zip_add_file(dm.scene_zip, "assets\\"+name+file_extension, file_path); 

//Create Data File
var ini_path = "assets\\"+name+".ini";
ini_open(ini_path);

//Asset Data
ini_write_string("Data", "name", name);
ini_write_real("Data", "type", type);
ini_write_string("Data", "path", string("assets\\"+name+file_extension));
ini_write_real("Position", "x", pos.x);
ini_write_real("Position", "y", pos.y);
ini_write_real("Position", "z", pos.z);
ini_write_real("Scale", "x", scale.x);
ini_write_real("Scale", "y", scale.y);
ini_write_real("Scale", "z", scale.z);
ini_write_real("Orientation", "x", orientation.x);
ini_write_real("Orientation", "y", orientation.y);
ini_write_real("Orientation", "z", orientation.z);
ini_write_real("Orientation", "w", orientation.w);
ini_write_real("Resolution", "width", art_w);
ini_write_real("Resolution", "height", art_h);

//End Asset Data
ini_close();

//Add Asset Data to .ZIP
zip_add_file(dm.scene_zip, ini_path, ini_path)

#endregion