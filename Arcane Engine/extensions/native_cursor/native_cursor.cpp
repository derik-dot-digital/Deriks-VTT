#pragma once
//#include "stdafx.h"
#include <vector>
#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
#include <optional>
#endif
#include <stdint.h>
#include <cstring>
#include <tuple>
using namespace std;

#define dllg /* tag */

/*#if defined(_WINDOWS)
#define dllx extern "C" __declspec(dllexport)
#elif defined(GNUC)
#define dllx extern "C" __attribute__ ((visibility("default")))
#else
#define dllx extern "C"
#endif*/
#define dllx extern "C" __declspec(dllexport)

#ifdef _WINDEF_
typedef HWND GAME_HWND;
#endif

/// Wraps a C++ pointer for GML.
template <typename T> using gml_ptr = T*;
/// Same as gml_ptr, but replaces the GML-side pointer by a nullptr after passing it to C++
template <typename T> using gml_ptr_destroy = T*;

struct gml_buffer {
private:
	uint8_t* _data;
	int32_t _size;
	int32_t _tell;
public:
	gml_buffer() : _data(nullptr), _tell(0), _size(0) {}
	gml_buffer(uint8_t* data, int32_t size, int32_t tell) : _data(data), _size(size), _tell(tell) {}

	inline uint8_t* data() { return _data; }
	inline int32_t tell() { return _tell; }
	inline int32_t size() { return _size; }
};

class gml_istream {
	uint8_t* pos;
	uint8_t* start;
public:
	gml_istream(void* origin) : pos((uint8_t*)origin), start((uint8_t*)origin) {}

	template<class T> T read() {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be read");
		T result{};
		std::memcpy(&result, pos, sizeof(T));
		pos += sizeof(T);
		return result;
	}

	char* read_string() {
		char* r = (char*)pos;
		while (*pos != 0) pos++;
		pos++;
		return r;
	}

	template<class T> std::vector<T> read_vector() {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be read");
		auto n = read<uint32_t>();
		std::vector<T> vec(n);
		std::memcpy(vec.data(), pos, sizeof(T) * n);
		pos += sizeof(T) * n;
		return vec;
	}

	gml_buffer read_gml_buffer() {
		auto _data = (uint8_t*)read<int64_t>();
		auto _size = read<int32_t>();
		auto _tell = read<int32_t>();
		return gml_buffer(_data, _size, _tell);
	}

	#pragma region Tuples
	#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
	template<typename... Args>
	std::tuple<Args...> read_tuple() {
		std::tuple<Args...> tup;
		std::apply([this](auto&&... arg) {
			((
				arg = this->read<std::remove_reference_t<decltype(arg)>>()
				), ...);
			}, tup);
		return tup;
	}

	template<class T> optional<T> read_optional() {
		if (read<bool>()) {
			return read<T>;
		} else return {};
	}
	#else
	template<class A, class B> std::tuple<A, B> read_tuple() {
		A a = read<A>();
		B b = read<B>();
		return std::tuple<A, B>(a, b);
	}

	template<class A, class B, class C> std::tuple<A, B, C> read_tuple() {
		A a = read<A>();
		B b = read<B>();
		C c = read<C>();
		return std::tuple<A, B, C>(a, b, c);
	}

	template<class A, class B, class C, class D> std::tuple<A, B, C, D> read_tuple() {
		A a = read<A>();
		B b = read<B>();
		C c = read<C>();
		D d = read<d>();
		return std::tuple<A, B, C, D>(a, b, c, d);
	}
	#endif
};

class gml_ostream {
	uint8_t* pos;
	uint8_t* start;
public:
	gml_ostream(void* origin) : pos((uint8_t*)origin), start((uint8_t*)origin) {}

	template<class T> void write(T val) {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be write");
		memcpy(pos, &val, sizeof(T));
		pos += sizeof(T);
	}

	void write_string(const char* s) {
		for (int i = 0; s[i] != 0; i++) write<char>(s[i]);
		write<char>(0);
	}

	template<class T> void write_vector(std::vector<T>& vec) {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be write");
		auto n = vec.size();
		write<uint32_t>(n);
		memcpy(pos, vec.data(), n * sizeof(T));
		pos += n * sizeof(T);
	}

	#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
	template<typename... Args>
	void write_tuple(std::tuple<Args...> tup) {
		std::apply([this](auto&&... arg) {
			(this->write(arg), ...);
			}, tup);
	}

	template<class T> void write_optional(optional<T>& val) {
		auto hasValue = val.has_value();
		write<bool>(hasValue);
		if (hasValue) write<T>(val.value());
	}
	#else
	template<class A, class B> void write_tuple(std::tuple<A, B>& tup) {
		write<A>(std::get<0>(tup));
		write<B>(std::get<1>(tup));
	}
	template<class A, class B, class C> void write_tuple(std::tuple<A, B, C>& tup) {
		write<A>(std::get<0>(tup));
		write<B>(std::get<1>(tup));
		write<C>(std::get<2>(tup));
	}
	template<class A, class B, class C, class D> void write_tuple(std::tuple<A, B, C, D>& tup) {
		write<A>(std::get<0>(tup));
		write<B>(std::get<1>(tup));
		write<C>(std::get<2>(tup));
		write<D>(std::get<3>(tup));
	}
	#endif
};
//{{NO_DEPENDENCIES}}
// Microsoft Visual C++ generated include file.
// Used by native_cursor.rc

// Next default values for new objects
// 
#ifdef APSTUDIO_INVOKED
#ifndef APSTUDIO_READONLY_SYMBOLS
#define _APS_NEXT_RESOURCE_VALUE        101
#define _APS_NEXT_COMMAND_VALUE         40001
#define _APS_NEXT_CONTROL_VALUE         1001
#define _APS_NEXT_SYMED_VALUE           101
#endif
#endif
// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#ifdef _WINDOWS
	#include "targetver.h"
	
	#define WIN32_LEAN_AND_MEAN // Exclude rarely-used stuff from Windows headers
	#include <windows.h>
#endif

#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
#define tiny_cpp17
#endif

#if defined(WIN32)
#define dllx extern "C" __declspec(dllexport)
#elif defined(GNUC)
#define dllx extern "C" __attribute__ ((visibility("default"))) 
#else
#define dllx extern "C"
#endif

#define _trace // requires user32.lib;Kernel32.lib
#define tiny_memset
#define tiny_memcpy
#define tiny_malloc
//#define tiny_dtoui3

#ifdef _trace
#ifdef _WINDOWS
void trace(const char* format, ...);
#else
#define trace(...) { printf("[native_cursor:%d] ", __LINE__); printf(__VA_ARGS__); printf("\n"); fflush(stdout); }
#endif
#endif

#pragma region typed memory helpers
template<typename T> T* malloc_arr(size_t count) {
	return (T*)malloc(sizeof(T) * count);
}
template<typename T> T* realloc_arr(T* arr, size_t count) {
	return (T*)realloc(arr, sizeof(T) * count);
}
template<typename T> T* memcpy_arr(T* dst, const T* src, size_t count) {
	return (T*)memcpy(dst, src, sizeof(T) * count);
}
#pragma endregion

#include "gml_ext.h"

// TODO: reference additional headers your program requires here
#pragma once

// Including SDKDDKVer.h defines the highest available Windows platform.

// If you wish to build your application for a previous Windows platform, include WinSDKVer.h and
// set the _WIN32_WINNT macro to the platform you wish to support before including SDKDDKVer.h.

#include <SDKDDKVer.h>
#pragma once
#include "stdafx.h"

template<typename T> class tiny_array {
	T* _data;
	size_t _size;
	size_t _capacity;

	bool add_impl(T value) {
		if (_size >= _capacity) {
			auto new_capacity = _capacity * 2;
			auto new_data = realloc_arr(_data, _capacity);
			if (new_data == nullptr) {
				trace("Failed to reallocate %u bytes in tiny_array::add", sizeof(T) * new_capacity);
				return false;
			}
			for (size_t i = _capacity; i < new_capacity; i++) new_data[i] = {};
			_data = new_data;
			_capacity = new_capacity;
		}
		_data[_size++] = value;
		return true;
	}
public:
	tiny_array() { }
	tiny_array(size_t capacity) { init(capacity); }
	inline void init(size_t capacity = 4) {
		if (capacity < 1) capacity = 1;
		_size = 0;
		_capacity = capacity;
		_data = malloc_arr<T>(capacity);
	}
	inline void free() {
		if (_data) {
			::free(_data);
			_data = nullptr;
		}
	}

	size_t size() { return _size; }
	size_t capacity() { return _capacity; }
	T* data() { return _data; }

	bool resize(size_t newsize, T value = {}) {
		if (newsize > _capacity) {
			auto new_data = realloc_arr(_data, newsize);
			if (new_data == nullptr) {
				trace("Failed to reallocate %u bytes in tiny_array::resize", sizeof(T) * newsize);
				return false;
			}
			_data = new_data;
			_capacity = newsize;
		}
		for (size_t i = _size; i < newsize; i++) _data[i] = value;
		for (size_t i = _size; --i >= newsize;) _data[i] = value;
		_size = newsize;
		return true;
	}

	#ifdef tiny_cpp17
	template<class... Args>
	inline bool add(Args... values) {
		return (add_impl(values) && ...);
	}
	#else
	inline void add(T value) {
		add_impl(value);
	}
	#endif

	bool remove(size_t index, size_t count = 1) {
		size_t end = index + count;
		if (end < _size) memcpy_arr(_data + start, _data + end, _size - end);
		_size -= end - index;
		return true;
	}

	bool set(T* values, size_t count) {
		if (!resize(count)) return false;
		memcpy_arr(_data, values, count);
		return true;
	}
	template<size_t count> inline bool set(T(&values)[count]) {
		return set(values, count);
	}

	T operator[] (size_t index) const { return _data[index]; }
	T& operator[] (size_t index) { return _data[index]; }
};#include "gml_ext.h"
// Struct forward declarations:
// from native_cursor.cpp:5:
struct native_cursor;
extern gml_ptr<native_cursor> native_cursor_create_from_buffer(gml_buffer buf, int width, int height, int hotspot_x, int hotspot_y, double fps);
dllx double native_cursor_create_from_buffer_raw(void* _inout_ptr, double _inout_ptr_size) {
	gml_istream _in(_inout_ptr);
	gml_buffer _arg_buf;
	_arg_buf = _in.read_gml_buffer();
	int _arg_width;
	_arg_width = _in.read<int>();
	int _arg_height;
	_arg_height = _in.read<int>();
	int _arg_hotspot_x;
	_arg_hotspot_x = _in.read<int>();
	int _arg_hotspot_y;
	_arg_hotspot_y = _in.read<int>();
	double _arg_fps;
	if (_in.read<bool>()) {
		_arg_fps = _in.read<double>();
	} else _arg_fps = 30;
	gml_ptr<native_cursor> _ret = native_cursor_create_from_buffer(_arg_buf, _arg_width, _arg_height, _arg_hotspot_x, _arg_hotspot_y, _arg_fps);
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((intptr_t)_ret);
	return 1;
}

extern void native_cursor_add_from_buffer(gml_ptr<native_cursor> cursor, gml_buffer buf, int width, int height, int hotspot_x, int hotspot_y);
dllx double native_cursor_add_from_buffer_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	gml_ptr<native_cursor> _arg_cursor;
	_arg_cursor = (gml_ptr<native_cursor>)_in.read<int64_t>();;
	gml_buffer _arg_buf;
	_arg_buf = _in.read_gml_buffer();
	int _arg_width;
	_arg_width = _in.read<int>();
	int _arg_height;
	_arg_height = _in.read<int>();
	int _arg_hotspot_x;
	_arg_hotspot_x = _in.read<int>();
	int _arg_hotspot_y;
	_arg_hotspot_y = _in.read<int>();
	native_cursor_add_from_buffer(_arg_cursor, _arg_buf, _arg_width, _arg_height, _arg_hotspot_x, _arg_hotspot_y);
	return 1;
}

extern gml_ptr<native_cursor> native_cursor_create_empty();
dllx double native_cursor_create_empty_raw(void* _inout_ptr, double _inout_ptr_size) {
	gml_istream _in(_inout_ptr);
	gml_ptr<native_cursor> _ret = native_cursor_create_empty();
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((intptr_t)_ret);
	return 1;
}

extern gml_ptr<native_cursor> native_cursor_create_from_full_path(const char* path);
dllx double native_cursor_create_from_full_path_raw(void* _inout_ptr, double _inout_ptr_size, const char* _arg_path) {
	gml_istream _in(_inout_ptr);
	gml_ptr<native_cursor> _ret = native_cursor_create_from_full_path(_arg_path);
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((intptr_t)_ret);
	return 1;
}

extern void native_cursor_add_from_full_path(gml_ptr<native_cursor> cursor, const char* path);
dllx double native_cursor_add_from_full_path_raw(void* _in_ptr, double _in_ptr_size, const char* _arg_path) {
	gml_istream _in(_in_ptr);
	gml_ptr<native_cursor> _arg_cursor;
	_arg_cursor = (gml_ptr<native_cursor>)_in.read<int64_t>();;
	native_cursor_add_from_full_path(_arg_cursor, _arg_path);
	return 1;
}

extern void native_cursor_set(gml_ptr<native_cursor> cursor);
dllx double native_cursor_set_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	gml_ptr<native_cursor> _arg_cursor;
	_arg_cursor = (gml_ptr<native_cursor>)_in.read<int64_t>();;
	native_cursor_set(_arg_cursor);
	return 1;
}

extern void native_cursor_reset();
dllx double native_cursor_reset_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	native_cursor_reset();
	return 1;
}

extern int native_cursor_get_frame(gml_ptr<native_cursor> cursor);
dllx double native_cursor_get_frame_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	gml_ptr<native_cursor> _arg_cursor;
	_arg_cursor = (gml_ptr<native_cursor>)_in.read<int64_t>();;
	return native_cursor_get_frame(_arg_cursor);
}

extern void native_cursor_set_frame(gml_ptr<native_cursor> cursor, int frame);
dllx double native_cursor_set_frame_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	gml_ptr<native_cursor> _arg_cursor;
	_arg_cursor = (gml_ptr<native_cursor>)_in.read<int64_t>();;
	int _arg_frame;
	_arg_frame = _in.read<int>();
	native_cursor_set_frame(_arg_cursor, _arg_frame);
	return 1;
}

extern double native_cursor_get_framerate(gml_ptr<native_cursor> cursor);
dllx double native_cursor_get_framerate_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	gml_ptr<native_cursor> _arg_cursor;
	_arg_cursor = (gml_ptr<native_cursor>)_in.read<int64_t>();;
	return native_cursor_get_framerate(_arg_cursor);
}

extern void native_cursor_set_framerate(gml_ptr<native_cursor> cursor, int fps);
dllx double native_cursor_set_framerate_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	gml_ptr<native_cursor> _arg_cursor;
	_arg_cursor = (gml_ptr<native_cursor>)_in.read<int64_t>();;
	int _arg_fps;
	_arg_fps = _in.read<int>();
	native_cursor_set_framerate(_arg_cursor, _arg_fps);
	return 1;
}

extern void native_cursor_destroy(gml_ptr_destroy<native_cursor> cursor);
dllx double native_cursor_destroy_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	gml_ptr_destroy<native_cursor> _arg_cursor;
	_arg_cursor = (gml_ptr_destroy<native_cursor>)_in.read<int64_t>();;
	native_cursor_destroy(_arg_cursor);
	return 1;
}

/// @author YellowAfterlife

#include "stdafx.h"

struct native_cursor {
	int count;
	double frameStart;
	uint64_t timeStart;
	uint64_t timeOffset;
	double timeMult;
	double framerate;
	HCURSOR* cursors;
	HBITMAP* bitmaps;
	uint8_t** pixelArrays;
	inline void init(int _count) {
		frameStart = 0;
		count = _count;
		timeStart = GetTickCount64();
		timeOffset = 0;
		timeMult = 30;
		framerate = 30;
		bitmaps = malloc_arr<HBITMAP>(_count);
		cursors = malloc_arr<HCURSOR>(_count);
		pixelArrays = malloc_arr<uint8_t*>(_count);
		for (int i = 0; i < _count; i++) {
			bitmaps[i] = nullptr;
			cursors[i] = nullptr;
			pixelArrays[i] = nullptr;
		}
	}
	inline void setFramerate(double fps) {
		framerate = fps;
		timeMult = fps / 1000.;
	}
	inline int addFrames(int _count) {
		auto start = count;
		auto newcount = start + _count;
		count = newcount;
		cursors = realloc_arr<HCURSOR>(cursors, newcount);
		bitmaps = realloc_arr<HBITMAP>(bitmaps, newcount);
		pixelArrays = realloc_arr<uint8_t*>(pixelArrays, newcount);
		for (int i = start; i < newcount; i++) {
			cursors[i] = nullptr;
			bitmaps[i] = nullptr;
			pixelArrays[i] = nullptr;
		}
		return start;
	}
	inline void clear() {
		cursors = NULL;
		bitmaps = NULL;
		pixelArrays = nullptr;
	}
	inline int getCurrentFrame() {
		if (count == 0) return -1;
		auto t = GetTickCount64() - timeStart;
		auto f = t * timeMult;
		#if (_M_IX86 == 600)
		// I don't want to implement all_rem myself
		auto fi = ((int)f) % count;
		if (fi < 0) fi += count;
		#else
		auto fi = ((int64_t)f) % count;
		if (fi < 0) fi += count;
		#endif
		//trace("cursor %d/%d->%x", fi, cur->count, cur->cursors[fi]);
		return (int)fi;
	}
	inline HCURSOR getCurrentCursor() {
		auto fi = getCurrentFrame();
		if (fi < 0) return NULL;
		return cursors[fi];
	}
	inline void free() {
		auto n = count;
		if (cursors) {
			for (int i = 0; i < n; i++) {
				if (cursors[i]) DestroyCursor(cursors[i]);
			}
			::free(cursors);
		}
		if (bitmaps) {
			for (int i = 0; i < n; i++) {
				if (bitmaps[i]) DeleteObject(bitmaps[i]);
			}
			::free(bitmaps);
		}
		if (pixelArrays) {
			for (int i = 0; i < n; i++) {
				if (pixelArrays[i]) ::free(pixelArrays[i]);
			}
			::free(pixelArrays);
		}
		clear();
	}
};
struct {
	native_cursor* cursor;
	HCURSOR hcursor;
	int x, y;
	bool inbound;
	LPARAM lastLPARAM;
	WPARAM lastWPARAM;
	inline void init() {
		cursor = nullptr;
		hcursor = NULL;
		x = 0; y = 0;
		inbound = false;
		lastLPARAM = 0;
		lastWPARAM = 0;
	}
} current;

static bool SwapRedBlue_needed;
void SwapRedBlue(BYTE* buf, size_t count) {
	if (!SwapRedBlue_needed) return;
	size_t i = 0;
	const size_t count_nand_15 = count & ~15;
	while (i < count_nand_15) {
		std::swap(buf[i], buf[i + 2]);
		std::swap(buf[i + 4], buf[i + 6]);
		std::swap(buf[i + 8], buf[i + 10]);
		std::swap(buf[i + 12], buf[i + 14]);
		i += 16;
	}
	for (; i < count; i += 4) std::swap(buf[i], buf[i + 2]);
}

bool native_cursor_apply_impl(bool force) {
	auto cur = current.cursor;
	if (cur == nullptr || cur->count <= 0) return false;
	if (!current.inbound) return false;
	auto hc = cur->getCurrentCursor();
	if (!force && hc == current.hcursor) return true;
	current.hcursor = hc;
	SetCursor(hc);
	return true;
}

HWND game_window;
WNDPROC wndproc_base;
LRESULT CALLBACK wndproc_hook(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp) {
	static int mx = 0, my = 0;
	switch (msg) {
		case WM_MOUSEMOVE:
			current.x = (short)LOWORD(lp);
			current.y = (short)HIWORD(lp);
			break;
		case WM_SETCURSOR:
			//trace("x=%d y=%d f=%d", current.x, current.y, (lp & 0xffff));
			
			// a clear miss if it says that it didn't hit client area:
			current.inbound = (lp & 0xffff) == HTCLIENT;
			current.lastLPARAM = lp;
			current.lastWPARAM = wp;
			if (!current.inbound) break;
			
			// why does Windows report hitting client area when mouseovering Win10 window shadow?
			do {
				RECT crect;
				if (!GetClientRect(hwnd, &crect)) continue;
				POINT mousePos;
				if (!GetCursorPos(&mousePos)) continue;
				if (!ScreenToClient(hwnd, &mousePos)) continue;
				//trace("mx=%d my=%d", mousePos.x, mousePos.y);
				if (PtInRect(&crect, mousePos)) continue;
				current.inbound = false;
			} while (false);
			if (!current.inbound) break;
			if (!native_cursor_apply_impl(true)) break;
			return TRUE;
	}
	return CallWindowProc(wndproc_base, hwnd, msg, wp, lp);
}
///
dllx void native_cursor_update() {
	auto cur = current.cursor;
	if (cur && cur->count > 1) native_cursor_apply_impl(false);
}

uint8_t* CreateBgraFromGmPixels(uint8_t* source, size_t size) {
	auto pixels = malloc_arr<uint8_t>(size);
	memcpy(pixels, source, size);
	SwapRedBlue(pixels, size);
	return pixels;
}
HBITMAP CreateBitmapFromBGRA(uint8_t* pixels, int width, int height) {
	auto bitmap = CreateBitmap(width, height, 1, 32, nullptr);
	auto dc = GetDC(NULL);
	BITMAPINFO bm{};
	auto& bmi = bm.bmiHeader;
	bmi.biSize = sizeof(bmi);
	bmi.biWidth = width;
	bmi.biHeight = -height;
	bmi.biPlanes = 1;
	bmi.biBitCount = 32;
	SetDIBits(dc, bitmap, 0, height, pixels, &bm, 0);
	ReleaseDC(NULL, dc);
	return bitmap;
}
HCURSOR CreateCursorFromBitmap(HBITMAP bitmap, int hotspot_x, int hotspot_y) {
	ICONINFO inf{};
	inf.fIcon = FALSE;
	inf.hbmColor = bitmap;
	inf.hbmMask = bitmap;
	inf.xHotspot = hotspot_x;
	inf.yHotspot = hotspot_y;
	return (HCURSOR)CreateIconIndirect(&inf);
}

dllg gml_ptr<native_cursor> native_cursor_create_from_buffer(gml_buffer buf, int width, int height, int hotspot_x, int hotspot_y, double fps = 30) {
	auto cur = malloc_arr<native_cursor>(1);
	auto size = (width * height * 4);
	if (buf.size() < size) return nullptr;

	cur->init(1);
	cur->setFramerate(fps);
	//
	auto pixels = CreateBgraFromGmPixels(buf.data(), (size_t)size);
	cur->pixelArrays[0] = pixels;
	//
	auto bitmap = CreateBitmapFromBGRA(pixels, width, height);
	cur->bitmaps[0] = bitmap;
	//
	auto cursor = CreateCursorFromBitmap(bitmap, hotspot_x, hotspot_y);
	cur->cursors[0] = cursor;
	if (cursor == NULL) trace("Failed to create cursor, GetLastError=%d", GetLastError());
	return cur;
}
dllg void native_cursor_add_from_buffer(gml_ptr<native_cursor> cursor, gml_buffer buf, int width, int height, int hotspot_x, int hotspot_y) {
	auto size = (width * height * 4);
	if (buf.size() < size) return;
	auto frame = cursor->addFrames(1);
	//
	auto pixels = CreateBgraFromGmPixels(buf.data(), (size_t)size);
	cursor->pixelArrays[frame] = pixels;
	//
	auto bitmap = CreateBitmapFromBGRA(pixels, width, height);
	cursor->bitmaps[frame] = bitmap;
	//
	auto hcursor = CreateCursorFromBitmap(bitmap, hotspot_x, hotspot_y);
	cursor->cursors[frame] = hcursor;
	if (hcursor == NULL) trace("Failed to create cursor, GetLastError=%d", GetLastError());
}

dllg gml_ptr<native_cursor> native_cursor_create_empty() {
	auto cur = malloc_arr<native_cursor>(1);
	cur->init(0);
	return cur;
}

dllg gml_ptr<native_cursor> native_cursor_create_from_full_path(const char* path) {
	auto wpathSize = MultiByteToWideChar(CP_UTF8, 0, path, -1, NULL, 0);
	auto wpath = malloc_arr<wchar_t>(wpathSize);
	MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath, wpathSize);
	auto cur = malloc_arr<native_cursor>(1);
	cur->init(1);
	cur->cursors[0] = LoadCursorFromFileW(wpath);
	::free(wpath);
	return cur;
}
dllg void native_cursor_add_from_full_path(gml_ptr<native_cursor> cursor, const char* path) {
	auto wpathSize = MultiByteToWideChar(CP_UTF8, 0, path, -1, NULL, 0);
	auto wpath = malloc_arr<wchar_t>(wpathSize);
	MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath, wpathSize);
	auto i = cursor->addFrames(1);
	cursor->cursors[i] = LoadCursorFromFileW(wpath);
	::free(wpath);
}
dllx double native_cursor_check_full_path(const char* path) {
	auto wpathSize = MultiByteToWideChar(CP_UTF8, 0, path, -1, NULL, 0);
	auto wpath = malloc_arr<wchar_t>(wpathSize);
	MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath, wpathSize);
	auto attrs = GetFileAttributesW(wpath);
	::free(wpath);
	return attrs != INVALID_FILE_ATTRIBUTES && ((attrs & FILE_ATTRIBUTE_DIRECTORY) == 0);
}

dllg void native_cursor_set(gml_ptr<native_cursor> cursor) {
	if (current.cursor) {
		current.cursor->timeOffset = GetTickCount64() - current.cursor->timeStart;
	}
	current.cursor = cursor;
	cursor->timeStart = GetTickCount64() - cursor->timeOffset;
	native_cursor_apply_impl(false);
}
dllg void native_cursor_reset() {
	if (current.cursor) {
		current.cursor->timeOffset = GetTickCount64() - current.cursor->timeStart;
	}
	current.cursor = nullptr;
	current.hcursor = nullptr;
	SetCursor(NULL);
	CallWindowProc(wndproc_base, game_window, WM_SETCURSOR, current.lastWPARAM, current.lastLPARAM);
}

dllg int native_cursor_get_frame(gml_ptr<native_cursor> cursor) {
	return cursor->getCurrentFrame();
}
dllg void native_cursor_set_frame(gml_ptr<native_cursor> cursor, int frame) {
	if (cursor->count <= 0) return;
	frame = frame % cursor->count;
	if (frame < 0) frame += cursor->count;
	if (cursor == current.cursor) {
		cursor->timeStart = GetTickCount64() - (int)(frame / cursor->timeMult);
	} else {
		cursor->timeOffset = (int)(frame / cursor->timeMult);
	}
}

dllg double native_cursor_get_framerate(gml_ptr<native_cursor> cursor) {
	return cursor->framerate;
}
dllg void native_cursor_set_framerate(gml_ptr<native_cursor> cursor, int fps) {
	cursor->setFramerate(fps);
}

dllg void native_cursor_destroy(gml_ptr_destroy<native_cursor> cursor) {
	if (cursor == current.cursor) {
		current.cursor = nullptr;
		current.hcursor = NULL;
		SetCursor(NULL);
		CallWindowProc(wndproc_base, game_window, WM_SETCURSOR, current.lastWPARAM, current.lastLPARAM);
	}
	cursor->free();
}


dllx void native_cursor_preinit_raw(void* _hwnd_as_ptr, double _swapBR) {
	SwapRedBlue_needed = _swapBR > 0.5;
	game_window = (HWND)_hwnd_as_ptr;
	if (wndproc_base == nullptr) {
		wndproc_base = (WNDPROC)SetWindowLongPtr(game_window, GWLP_WNDPROC, (LONG_PTR)wndproc_hook);
	}
}


bool native_cursor_preinit_statics() {
	SwapRedBlue_needed = false;
	wndproc_base = nullptr;
	current.init();
	return true;
}

#ifdef NDEBUG
BOOL APIENTRY DllMain(HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved) {
	if (ul_reason_for_call == DLL_PROCESS_ATTACH) {
		native_cursor_preinit_statics();
	}
	return TRUE;
}
#else
static bool __ready__ = native_cursor_preinit_statics();
#endif// stdafx.cpp : source file that includes just the standard includes
// native_cursor.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"
#include <strsafe.h>
#ifdef tiny_dtoui3
#include <intrin.h>
#endif

#if _WINDOWS
// http://computer-programming-forum.com/7-vc.net/07649664cea3e3d7.htm
extern "C" int _fltused = 0;
#endif

// TODO: reference any additional headers you need in STDAFX.H
// and not in this file
#ifdef _trace
#ifdef _WINDOWS
// https://yal.cc/printf-without-standard-library/
void trace(const char* pszFormat, ...) {
	char buf[1025];
	va_list argList;
	va_start(argList, pszFormat);
	wvsprintfA(buf, pszFormat, argList);
	va_end(argList);
	DWORD done;
	auto len = strlen(buf);
	buf[len] = '\n';
	buf[++len] = 0;
	WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), buf, len, &done, NULL);
}
#endif
#endif

#pragma warning(disable: 28251 28252)

#ifdef NDEBUG
#ifdef tiny_memset
#pragma function(memset)
void* __cdecl memset(void* _Dst, _In_ int _Val,_In_ size_t _Size) {
	auto ptr = static_cast<uint8_t*>(_Dst);
	while (_Size) {
		*ptr++ = _Val;
		_Size--;
	}
	return _Dst;
}
#endif

#ifdef tiny_memcpy
#pragma function(memcpy)
void* memcpy(void* _Dst, const void* _Src, size_t _Size) {
	auto src8 = static_cast<const uint64_t*>(_Src);
	auto dst8 = static_cast<uint64_t*>(_Dst);
	for (; _Size > 32; _Size -= 32) {
		*dst8++ = *src8++;
		*dst8++ = *src8++;
		*dst8++ = *src8++;
		*dst8++ = *src8++;
	}
	for (; _Size > 8; _Size -= 8) *dst8++ = *src8++;
	//
	auto src1 = (const uint8_t*)(src8);
	auto dst1 = (uint8_t*)(dst8);
	for (; _Size != 0; _Size--) *dst1++ = *src1++;
	return _Dst;
}
#endif

#ifdef tiny_malloc
void* __cdecl malloc(size_t _Size) {
	return HeapAlloc(GetProcessHeap(), 0, _Size);
}
void* __cdecl realloc(void* _Block, size_t _Size) {
	return HeapReAlloc(GetProcessHeap(), 0, _Block, _Size);
}
void __cdecl free(void* _Block) {
	HeapFree(GetProcessHeap(), 0, _Block);
}
#endif

#ifdef tiny_dtoui3
// https:/stackoverflow.com/a/55011686/5578773
extern "C" unsigned int _dtoui3(const double x) {
	return (unsigned int)_mm_cvttsd_si32(_mm_set_sd(x));
}
#endif
#endif

#pragma warning(default: 28251 28252)
