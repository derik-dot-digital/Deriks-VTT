var is_character = 0; if type = asset_types.player or type = asset_types.npc {is_character = 1;}
if is_character {
	//var shadow_cast = cm_cast_ray(global.collision, cm_ray(pos.x, pos.y, pos.z-10, pos.x, pos.y, pos.z-100));
	draw_sprite_ext(spr_pixel, 0, pos.x-(art_w/2), pos.y-(art_h/2), art_w, art_h, 0, c_white, 1);
}