if file_exists(file_path) {file_delete(file_path);}
if buffer_exists(vbuff) {vertex_delete_buffer(vbuff);}
cm_remove(global.collision, col_dynamic);
if selected {global.selected_inst = noone;}