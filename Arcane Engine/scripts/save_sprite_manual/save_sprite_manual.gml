function sprite_save_manual(_sprite, _subimg, _path){
	show_debug_message("1")
	var q = sprite_duplicate(_sprite);
	var qw = sprite_get_width(q);
	var qh = sprite_get_height(q);
	var qx = sprite_get_xoffset(q);
	var qy = sprite_get_yoffset(q);
	var t = surface_create(qw, qh, surface_rgba8unorm);
		show_debug_message("2")
	surface_set_target(t);
		show_debug_message("3")
	draw_clear_alpha(c_black, 0);
	gpu_set_blendmode(bm_add);
	draw_sprite(q, _subimg, qx, qy);
	show_debug_message("4")
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
	show_debug_message("5")
	surface_resize(t, 100, 100)
	surface_save(t, "test.png");
	show_debug_message("6")
	surface_free(t);
	show_debug_message("7")
}