//image file
if file_exists_ns(file_path) {file_delete_ns(file_path);}

//Vertex Buffer
if buffer_exists(vbuff) {vertex_delete_buffer(vbuff);}

//Collision Shape
cm_remove(global.collision, col_dynamic);

//Clear Selection
if selected {global.selected_inst = noone;}