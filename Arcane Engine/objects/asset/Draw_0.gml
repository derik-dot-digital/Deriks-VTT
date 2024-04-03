#region Draw 

//Check Type
if type = asset_types.empty {
}

//Art
if type = asset_types.art{
	if col_shape = undefined or vbuff = undefined {
		var cm_setup =  cm_vbuff_plane();
		vbuff = cm_setup[0];
		col_shape = cm_setup[1];
		scale = new vec3(art_w, art_h, 1);
		col_dynamic = cm_dynamic(col_shape, orientation.Conjugate().AsTransformMatrix(pos, scale));
		cm_custom_parameter_set(col_dynamic, id);
		cm_add(global.collision, col_dynamic);
		}
	if art != undefined {
	shader_set(shd_asset);
	scale = new vec3(art_w, art_h, 1);
	var object_data = [];
	cm_dynamic_set_matrix(col_dynamic, orientation.Conjugate().AsTransformMatrix(pos, default_scale), false, scale);
	object_data = array_concat(object_data, pos.AsLinearArray(), orientation.AsLinearArray(), scale.AsLinearArray());
	array_push(object_data, global.outline_size, global.outline_size, selected);
	var uni_object_data = shader_get_uniform(shd_asset, "object_data");
	shader_set_uniform_f_array(uni_object_data, object_data);
	cm_vbuff_submit(vbuff, sprite_get_texture(art, 0));
	shader_reset();
	}
}

//Draw Collision Shape
if col_dynamic != undefined and draw_col_shape {
shader_set(sh_cm_debug);
cm_debug_draw(col_dynamic);
shader_reset();
}
	
#endregion