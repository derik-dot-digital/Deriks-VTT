function cm_vbuff_add_vertex(vbuff, position = new vec3(0, 0, 0), normal = new vec3(0, 0, 0), texcoord = new vec2(0, 0), color = c_white, alpha = 1) {
	vertex_position_3d(vbuff, position.x, position.y, position.z);
	vertex_normal(vbuff, normal.x, normal.y, normal.z)
	vertex_texcoord(vbuff, texcoord.x, texcoord.y);
	vertex_color(vbuff, color, alpha)
}

function cm_vbuff_generate_tri_normals(p1, p2, p3) {
	var nx = (p2.y - p1.y) * (p3.z - p1.z) - (p2.z - p1.z) * (p3.y - p1.y);
	var ny = (p2.z - p1.z) * (p3.x - p1.x) - (p2.x - p1.x) * (p3.z - p1.z);
	var nz = (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x);
	return new vec3(nx, ny, nz).Normalize();
}
	
function cm_vbuff_add_tri(vbuff, p1, p2, p3, normal, tex1, tex2, tex3, c1, c2, c3, a1, a2, a3) {
	cm_vbuff_add_vertex(vbuff, p1, normal, tex1, c1, a1);
	cm_vbuff_add_vertex(vbuff, p2, normal, tex2, c2, a2);
	cm_vbuff_add_vertex(vbuff, p3, normal, tex3, c3, a3);
}

function cm_triangle_ext(singlesided, p1, p2, p3) {
return cm_triangle(singlesided, p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, p3.x, p3.y, p3.z);
}

//Flat Plane
function cm_vbuff_plane() {
	var cm = cm_list();
	var vb = vertex_create_buffer();
	cm_vbuff_begin(vb);
	var scale = 0.5;
	var p1 = new vec3(-scale, -scale, 0);
	var p2 = new vec3(-scale, scale, 0);
	var p3 = new vec3(scale, -scale, 0);
	var p4 = new vec4(scale, scale, 0);
	var t = global.texcoords;
	var c = c_white;
	var a = 1;
	var n1 = cm_vbuff_generate_tri_normals(p1, p2, p3);
	var n2 = cm_vbuff_generate_tri_normals(p2, p3, p4);
	cm_vbuff_add_tri(vb, p1, p2, p3, n1, t[0], t[1], t[2], c, c, c, a, a, a);
	cm_vbuff_add_tri(vb, p2, p3, p4, n1, t[1], t[2], t[3], c, c, c, a, a, a);
	cm_vbuff_end(vb);
	cm_add(cm, cm_triangle_ext(false, p1, p2, p3));
	cm_add(cm, cm_triangle_ext(false, p2, p3, p4));
	return [vb, cm];
}
	
function mouse_to_world_cast() {
	var ww = win_w;
	var wh = win_h;
	var _v = camera.mat_view;
	var _p = camera.mat_projection;
	var _mx = (window_mouse_get_x() / ww);
	var _my = 1-(window_mouse_get_y() / wh);
	var _2dto3d = cm_2d_to_3d(_v, _p, _mx, _my);
	var _ray_dist = 100000;
	var _ray = cm_ray(_2dto3d[3],  _2dto3d[4],  _2dto3d[5], _2dto3d[3] + _2dto3d[0] * _ray_dist, _2dto3d[4] + _2dto3d[1] * _ray_dist, _2dto3d[5] + _2dto3d[2] * _ray_dist);
	var _cast = cm_cast_ray(global.collision, _ray);
	return [_cast[CM_RAY.HIT], _cast[CM_RAY.X], _cast[CM_RAY.Y], _cast[CM_RAY.Z], _cast[CM_RAY.NX], _cast[CM_RAY.NY], _cast[CM_RAY.NZ], _cast[CM_RAY.OBJECT]];
}


function cm_ray_get_nx(ray) {
	return ray[CM_RAY.NX];
}
function cm_ray_get_ny(ray) {
	return ray[CM_RAY.NY];
}
function cm_ray_get_nz(ray) {
	return  ray[CM_RAY.NZ];
}