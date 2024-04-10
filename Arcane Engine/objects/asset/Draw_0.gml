#region Draw 

//Art & Maps
if type = asset_types.art or type = asset_types.map {
	if col_shape = undefined or vbuff = undefined {
		var cm_setup =  cm_vbuff_plane();
		vbuff = cm_setup[0];
		col_shape = cm_setup[1];
		var active_scale = scale.Mul(new vec3(art_w, art_h, 1));
		col_dynamic = cm_dynamic(col_shape, orientation.Conjugate().AsTransformMatrix(pos, active_scale));
		cm_custom_parameter_set(col_dynamic, id);
		cm_add(global.collision, col_dynamic);
		}
	if sprite_exists(art) {
	shader_set(shd_asset);
	var active_scale = scale.Mul(new vec3(art_w, art_h, 1));
	var object_data = [];
	cm_dynamic_set_matrix(col_dynamic, orientation.Conjugate().AsTransformMatrix(pos, default_scale), false, active_scale);
	object_data = array_concat(object_data, pos.AsLinearArray(), orientation.AsLinearArray(), active_scale.AsLinearArray());
	array_push(object_data, global.outline_size, global.outline_size, selected);
	var uni_object_data = shader_get_uniform(shd_asset, "object_data");
	shader_set_uniform_f_array(uni_object_data, object_data);
	cm_vbuff_submit(vbuff, sprite_get_texture(art, 0));
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