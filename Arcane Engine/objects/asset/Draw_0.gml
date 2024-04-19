#region Draw 

//2D Assets
if type = asset_types.art or type = asset_types.map or type  = asset_types.player or type = asset_types.npc {
	
	//Collision Setup
	if col_shape = undefined or vbuff = undefined {
		
	//Generate 2D Plane
	var cm_setup =  cm_vbuff_plane();
		
	//Grab Vertex Buffer
	vbuff = cm_setup[0];
		
	//Grab Colmesh Shape
	col_shape = cm_setup[1];
		
	//Calculate Resolution Independant Scale
	var active_scale = scale.Mul(new vec3(art_w, art_h, 1));
		
	//Define Colmesh Dynamic
	col_dynamic = cm_dynamic(col_shape, orientation.Conjugate().AsTransformMatrix(pos, active_scale));
		
	//Store Instance ID in Collision Dynamic
	cm_custom_parameter_set(col_dynamic, id);
		
	//Add to Scene Collision
	cm_add(global.collision, col_dynamic);
		
	}
	
	//Character?
	var is_character = 0; if type = asset_types.player or type = asset_types.npc {is_character = 1;}
	
	//Render
	if sprite_exists(art) {
		
	//Set Shader
	shader_set(shd_asset);
		
	//Calculate Resolution Independant Scale
	var active_scale = scale.Mul(new vec3(art_w, art_h, 1));
	
	//Store Uniforms in a single array to minimize vbatches
	var object_data = [];
	object_data = array_concat(object_data, pos.AsLinearArray(), orientation.AsLinearArray(), active_scale.AsLinearArray());
	array_push(object_data, global.outline_size, global.outline_size, selected, is_character);
	
	//Pass Uniforms to Shader
	var uni_object_data = shader_get_uniform(shd_asset, "object_data");
	shader_set_uniform_f_array(uni_object_data, object_data);
	shader_set_uniform_f(shader_get_uniform(shd_asset, "resolution"), sprite_get_width(art), sprite_get_height(art));
	
	//Update Collision Shape Matrix
	cm_dynamic_set_matrix(col_dynamic, orientation.Conjugate().AsTransformMatrix(pos, default_scale), false, active_scale);
	
	//Draw
	cm_vbuff_submit(vbuff, sprite_get_texture(art, 0));
	
	//Reset Shader
	shader_reset();
	
	}		
}

//Draw Collision Shape
if col_dynamic != undefined and draw_col_shape {
	
	//Set ColMesh Debug Shader
	shader_set(sh_cm_debug);
	
	//Draw Dynamic Collision Shape
	cm_debug_draw(col_dynamic);
	
	//Reset Shader
	shader_reset();
	
}
	
#endregion