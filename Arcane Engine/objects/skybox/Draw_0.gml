//Clear Surface for new frame
if enabled {
	
	//Default Color
	var _c = c_black;
	
	//Solid Color
	if mode = skybox_modes.solid_color {_c = color;}
	
	//Solid Rainbow
	if mode = skybox_modes.solid_rainbow {_c = skybox_solid_rainbow;}
	
	//Animate Rainbow
	rainbow_frame +=rainbow_spd;
	
	//Clear Frame
	draw_clear_alpha(_c, 1);
	
	//Dynamic
	if mode = skybox_modes.dynamic {
		
		//Calculate Sun Vector
		sun_vector = sun_vector.Rotate(world_x, 0.01);
		
		//Force Rendering Behind scene
		gpu_set_zwriteenable(false);	
		
		//Set Matrix
		matrix_set(matrix_world, mat_skybox);
		
		//Set Shader
		shader_set(shd_skybox_dynamic);
		
		//Colors
		var c_day = new vec3(135, 206, 235).ColortoShader();
		var c_night = new vec3(0, 0, 0);
		
		//Store Uniforms in an Array
		var settings_array = [];
		var variables = [dynamic_style];
		settings_array = array_concat(c_day.AsLinearArray(), c_night.AsLinearArray(), sun_vector.AsLinearArray(), variables);
		
		//Pass Array to Shader
		shader_set_uniform_f_array(uni_array, settings_array);
		
		//Draw
		vertex_submit(vbuff, pr_trianglelist, vbuff_tex);
		
		//Reset Shader
		shader_reset();
		
		//Reset Matrix
		matrix_set(matrix_world, mat_default);

		//Re-enable Depth
		gpu_set_zwriteenable(true);	

}
	
	//HDRI
	if mode = skybox_modes.hdri {
		
		//Force Rendering Behind scene
		gpu_set_zwriteenable(false);	
		
		//Set Shader
		shader_set( shd_skybox_hdri );
		
		//Clamp Index
		hdri_index = clamp(hdri_index, 0, sprite_get_number(skybox_hdris)-1);
		
		//Draw
		draw_sprite_stretched(skybox_hdris, hdri_index, -1,-1,2,2);
				
		//Reset Shader
		shader_reset();
	
		//Re-enable Depth
		gpu_set_zwriteenable(true);	
		
	}
}