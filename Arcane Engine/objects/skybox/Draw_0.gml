//Clear Surface for new frame
if enabled {
	var _c = c_black;
	if mode = skybox_modes.solid_color {_c = color;}
	if mode = skybox_modes.solid_rainbow {_c = skybox_solid_rainbow;}
	draw_clear_alpha(_c, 1);
	rainbow_frame +=rainbow_spd;
	if mode = skybox_modes.dynamic {
		sun_vector = sun_vector.Rotate(world_x, 0.01);
		gpu_set_zwriteenable(false);	
		matrix_set(matrix_world, mat_skybox);
		shader_set(shd_skybox);
		var c_day = new vec3(135, 206, 235).ColortoShader();
		var c_night = new vec3(0, 0, 0);
		var settings_array = [];
		var variables = [dynamic_shader_mode, dynamic_blend_mode];
		settings_array = array_concat(c_day.AsLinearArray(), c_night.AsLinearArray(), sun_vector.AsLinearArray());
		shader_set_uniform_f_array(uni_array, settings_array);
		vertex_submit(vbuff, pr_trianglelist, vbuff_tex);
		matrix_set(matrix_world, mat_default);
		shader_reset();
		gpu_set_zwriteenable(true);	
	}
} else {
	draw_clear_alpha(0, 0);
}