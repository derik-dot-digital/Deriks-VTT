#region Initialize

//Mode
enum skybox_modes {
	solid_color,
	solid_rainbow,
	rainbow_wave,
	dynamic,
	cubemap,
	hdri
}
mode = skybox_modes.solid_color;

//Enabled/Disabled
enabled = false;

//Color Settings
color = c_black;
rainbow_spd = 0;
rainbow_frame = 0
enum skybox_dynamic_styles {
	solid,
	gradient
}
dynamic_style = skybox_dynamic_styles.solid;
sun_vector = world_up.Negate();

//Store vBuffer Values
vbuff_skybox_cube = cm_create_block_vbuff(1, 1, c_white);
vbuff_skybox_sphere = cm_create_sphere_vbuff(32, 32, 1, 1, c_white);
vbuff = vbuff_skybox_sphere;
vbuff_tex = -1

//HDRI Settings
hdri_index = 0;

//Settings Array Uniform
uni_array = shader_get_uniform(shd_skybox_dynamic, "uniform_array");

//Macros
#macro mat_skybox matrix_build(camera.pos.x, camera.pos.y, camera.pos.z, 0, 0, 0, 1000, 1000, 1000)
#macro skybox_solid_rainbow make_color_hsv(rainbow_frame mod 255,255,255)

#endregion