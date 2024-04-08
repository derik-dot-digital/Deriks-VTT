#region Save Scene Settings & Camera Data to .ZIP

//Create Config Data
ini_open("scene_config"+".ini");

//Camera Data
ini_write_real("View Quat", "x", view_quat.x);
ini_write_real("View Quat", "y", view_quat.y);
ini_write_real("View Quat", "z", view_quat.z);
ini_write_real("View Quat", "w", view_quat.w);
ini_write_real("Camera Position", "x", pos.x);
ini_write_real("Camera Position", "y", pos.y);
ini_write_real("Camera Position", "z", pos.z);
ini_write_real("Camera Target", "x", target.x);
ini_write_real("Camera Target", "y", target.y);
ini_write_real("Camera Target", "z", target.z);
ini_write_real("Camera Direction", "x", dir.x);
ini_write_real("Camera Direction", "y", dir.y);
ini_write_real("Camera Direction", "z", dir.z);
ini_write_real("Camera Up", "x", up.x);
ini_write_real("Camera Up", "y", up.y);
ini_write_real("Camera Up", "z", up.z);
ini_write_real("Projection Settings", "fov", fov);
ini_write_real("Projection Settings", "znear_perspective", znear_perspective);
ini_write_real("Projection Settings", "znear_orthographic", znear_ortho);
ini_write_real("Projection Settings", "zfar", zfar);
ini_write_real("Projection Settings", "projection_slider", projection_slider);
ini_write_real("Projection Settings", "zoom", zoom);
ini_write_real("Projection Settings", "zoom_strength", zoom_strength);

//Grid Data
ini_write_real("Grid Settings", "grid_size", grid.grid_size);
ini_write_real("Grid Settings", "tile_size", grid.tile_size);
ini_write_string("Grid Settings", "depth_mode", grid.depth_mode);
ini_write_real("Grid Settings", "color_mode", grid.color_mode);
ini_write_real("Grid Settings", "grid_color_red", grid.grid_color.x);
ini_write_real("Grid Settings", "grid_color_green", grid.grid_color.y);
ini_write_real("Grid Settings", "grid_color_blue", grid.grid_color.z);
ini_write_real("Grid Settings", "grid_color_alpha", grid.grid_color.w);
ini_write_real("Grid Settings", "rainbow_color_scale", grid.rainbow_color_scale);
ini_write_real("Grid Settings", "rainbow_color_spd", grid.rainbow_color_spd);

//End Config Data
ini_close();

//Add Config to .ZIP
zip_add_file(dm.scene_zip, "scene_config"+".ini", "scene_config"+".ini")

#endregion