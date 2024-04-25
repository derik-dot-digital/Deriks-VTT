//Load File as Buffer
var test = buffer_load(file_path); 

//Store Raw buffer values
var raw_size = buffer_get_size(test);
var raw_address = buffer_get_address(test);
var raw_type = buffer_get_type(test);

//Save Buffer Raw
buffer_save(test, directory_get_desktop_path()+"test_raw.png");

//Compress Buffer
test = buffer_compress(test, 0, buffer_get_size(test));

//show_debug_message(buffer_prettyprint(test, 20));

//Store Compressed buffer values
var compressed_size = buffer_get_size(test);
var compressed_address = buffer_get_address(test);
var compressed_type = buffer_get_type(test);

//Save Compressed Buffer
buffer_save(test, directory_get_desktop_path()+"test_compressed.png");

//Decompress Buffer
test = buffer_decompress(test);
//Store Compressed buffer values
var uncompressed_size = buffer_get_size(test);
var uncompressed_address = buffer_get_address(test);
var uncompressed_type = buffer_get_type(test);

//Save uncompressed buffer
buffer_save(test, directory_get_desktop_path()+"test_uncompressed.png");
