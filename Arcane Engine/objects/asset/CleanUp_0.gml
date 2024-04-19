if file_exists_ns(file_path) {file_delete_ns(file_path);}
if buffer_exists(vbuff) {vertex_delete_buffer(vbuff);}
cm_remove(global.collision, col_dynamic);
if selected {global.selected_inst = noone;}