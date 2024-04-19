#define native_cursor_create_from_buffer
/// native_cursor_create_from_buffer(buf:buffer, width:int, height:int, hotspot_x:int, hotspot_y:int, fps:number = 30)->
var _buf = native_cursor_prepare_buffer(41);
var _val_0 = argument[0];
if (buffer_exists(_val_0)) {
	buffer_write(_buf, buffer_u64, int64(buffer_get_address(_val_0)));
	buffer_write(_buf, buffer_s32, buffer_get_size(_val_0));
	buffer_write(_buf, buffer_s32, buffer_tell(_val_0));
} else {
	buffer_write(_buf, buffer_u64, 0);
	buffer_write(_buf, buffer_s32, 0);
	buffer_write(_buf, buffer_s32, 0);
}
buffer_write(_buf, buffer_s32, argument[1]);
buffer_write(_buf, buffer_s32, argument[2]);
buffer_write(_buf, buffer_s32, argument[3]);
buffer_write(_buf, buffer_s32, argument[4]);
if (argument_count >= 6) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_f64, argument[5]);
} else buffer_write(_buf, buffer_bool, false);
if (native_cursor_create_from_buffer_raw(buffer_get_address(_buf), 41)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _ptr_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_ptr_0 != 0) {
		_box_0 = new native_cursor(ptr(_ptr_0));
	} else _box_0 = undefined;
	return _box_0;
	/*/
	var _ptr_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_ptr_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_native_cursor;
		_box_0[1] = ptr(_ptr_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
} else return undefined;

#define native_cursor_add_from_buffer
/// native_cursor_add_from_buffer(cursor, buf:buffer, width:int, height:int, hotspot_x:int, hotspot_y:int)
var _buf = native_cursor_prepare_buffer(40);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "native_cursor") { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0.__ptr__;
if (_ptr_0 == pointer_null) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
var _val_0 = argument1;
if (buffer_exists(_val_0)) {
	buffer_write(_buf, buffer_u64, int64(buffer_get_address(_val_0)));
	buffer_write(_buf, buffer_s32, buffer_get_size(_val_0));
	buffer_write(_buf, buffer_s32, buffer_tell(_val_0));
} else {
	buffer_write(_buf, buffer_u64, 0);
	buffer_write(_buf, buffer_s32, 0);
	buffer_write(_buf, buffer_s32, 0);
}
buffer_write(_buf, buffer_s32, argument2);
buffer_write(_buf, buffer_s32, argument3);
buffer_write(_buf, buffer_s32, argument4);
buffer_write(_buf, buffer_s32, argument5);
/*/
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_native_cursor) { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0[1];
if (int64(_ptr_0) == 0) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
var _val_0 = argument1;
if (buffer_exists(_val_0)) {
	buffer_write(_buf, buffer_u64, int64(buffer_get_address(_val_0)));
	buffer_write(_buf, buffer_s32, buffer_get_size(_val_0));
	buffer_write(_buf, buffer_s32, buffer_tell(_val_0));
} else {
	buffer_write(_buf, buffer_u64, 0);
	buffer_write(_buf, buffer_s32, 0);
	buffer_write(_buf, buffer_s32, 0);
}
buffer_write(_buf, buffer_s32, argument2);
buffer_write(_buf, buffer_s32, argument3);
buffer_write(_buf, buffer_s32, argument4);
buffer_write(_buf, buffer_s32, argument5);
//*/
native_cursor_add_from_buffer_raw(buffer_get_address(_buf), 40);

#define native_cursor_create_empty
/// native_cursor_create_empty()->
var _buf = native_cursor_prepare_buffer(8);
if (native_cursor_create_empty_raw(buffer_get_address(_buf), 8)) {
	// GMS >= 2.3:
	var _ptr_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_ptr_0 != 0) {
		_box_0 = new native_cursor(ptr(_ptr_0));
	} else _box_0 = undefined;
	return _box_0;
	/*/
	var _ptr_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_ptr_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_native_cursor;
		_box_0[1] = ptr(_ptr_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
} else return undefined;

#define native_cursor_create_from_full_path
/// native_cursor_create_from_full_path(path:string)->
var _buf = native_cursor_prepare_buffer(8);
if (native_cursor_create_from_full_path_raw(buffer_get_address(_buf), 8, argument0)) {
	// GMS >= 2.3:
	var _ptr_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_ptr_0 != 0) {
		_box_0 = new native_cursor(ptr(_ptr_0));
	} else _box_0 = undefined;
	return _box_0;
	/*/
	var _ptr_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_ptr_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_native_cursor;
		_box_0[1] = ptr(_ptr_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
} else return undefined;

#define native_cursor_add_from_full_path
/// native_cursor_add_from_full_path(cursor, path:string)
var _buf = native_cursor_prepare_buffer(16);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "native_cursor") { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0.__ptr__;
if (_ptr_0 == pointer_null) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
/*/
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_native_cursor) { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0[1];
if (int64(_ptr_0) == 0) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
//*/
native_cursor_add_from_full_path_raw(buffer_get_address(_buf), 16, argument1);

#define native_cursor_set
/// native_cursor_set(cursor)
var _buf = native_cursor_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "native_cursor") { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0.__ptr__;
if (_ptr_0 == pointer_null) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
/*/
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_native_cursor) { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0[1];
if (int64(_ptr_0) == 0) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
//*/
native_cursor_set_raw(buffer_get_address(_buf), 8);

#define native_cursor_reset
/// native_cursor_reset()
var _buf = native_cursor_prepare_buffer(1);
native_cursor_reset_raw(buffer_get_address(_buf), 1);

#define native_cursor_get_frame
/// native_cursor_get_frame(cursor)->int
var _buf = native_cursor_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "native_cursor") { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0.__ptr__;
if (_ptr_0 == pointer_null) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
/*/
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_native_cursor) { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0[1];
if (int64(_ptr_0) == 0) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
//*/
return native_cursor_get_frame_raw(buffer_get_address(_buf), 8);

#define native_cursor_set_frame
/// native_cursor_set_frame(cursor, frame:int)
var _buf = native_cursor_prepare_buffer(12);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "native_cursor") { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0.__ptr__;
if (_ptr_0 == pointer_null) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
buffer_write(_buf, buffer_s32, argument1);
/*/
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_native_cursor) { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0[1];
if (int64(_ptr_0) == 0) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
buffer_write(_buf, buffer_s32, argument1);
//*/
native_cursor_set_frame_raw(buffer_get_address(_buf), 12);

#define native_cursor_get_framerate
/// native_cursor_get_framerate(cursor)->number
var _buf = native_cursor_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "native_cursor") { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0.__ptr__;
if (_ptr_0 == pointer_null) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
/*/
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_native_cursor) { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0[1];
if (int64(_ptr_0) == 0) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
//*/
return native_cursor_get_framerate_raw(buffer_get_address(_buf), 8);

#define native_cursor_set_framerate
/// native_cursor_set_framerate(cursor, fps:int)
var _buf = native_cursor_prepare_buffer(12);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "native_cursor") { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0.__ptr__;
if (_ptr_0 == pointer_null) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
buffer_write(_buf, buffer_s32, argument1);
/*/
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_native_cursor) { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0[1];
if (int64(_ptr_0) == 0) { show_error("This native_cursor is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, int64(_ptr_0));
buffer_write(_buf, buffer_s32, argument1);
//*/
native_cursor_set_framerate_raw(buffer_get_address(_buf), 12);

#define native_cursor_destroy
/// native_cursor_destroy(cursor)
var _buf = native_cursor_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "native_cursor") { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0.__ptr__;
if (_ptr_0 == pointer_null) { show_error("This native_cursor is destroyed.", true); exit; }
_box_0.__ptr__ = ptr(0);
buffer_write(_buf, buffer_u64, int64(_ptr_0));
/*/
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_native_cursor) { show_error("Expected a native_cursor, got " + string(_box_0), true); exit }
var _ptr_0 = _box_0[1];
if (int64(_ptr_0) == 0) { show_error("This native_cursor is destroyed.", true); exit; }
_box_0[@1] = ptr(0);
buffer_write(_buf, buffer_u64, int64(_ptr_0));
//*/
native_cursor_destroy_raw(buffer_get_address(_buf), 8);

