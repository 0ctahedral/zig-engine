//! All the functions we are going to use
pub const Display = extern opaque{};
pub const xcb_connection_t = extern opaque{};
pub const xcb_keycode_t = u8;
pub const xcb_colormap_t = u32;
pub const xcb_visualid_t = u32;
pub const xcb_window_t = u32;
pub const xcb_setup_t = extern struct {
    status: u8,
    pad0: u8,
    protocol_major_version: u16,
    protocol_minor_version: u16,
    length: u16,
    release_number: u32,
    resource_id_base: u32,
    resource_id_mask: u32,
    motion_buffer_size: u32,
    vendor_len: u16,
    maximum_request_length: u16,
    roots_len: u8,
    pixmap_formats_len: u8,
    image_byte_order: u8,
    bitmap_format_bit_order: u8,
    bitmap_format_scanline_unit: u8,
    bitmap_format_scanline_pad: u8,
    min_keycode: xcb_keycode_t,
    max_keycode: xcb_keycode_t,
    pad1: [4]u8,
};
pub const xcb_screen_iterator_t = extern struct {
    data: [*]xcb_screen_t,
    rem: u32,
    index: u32,
};
pub const xcb_screen_t = extern struct {
    root: xcb_window_t,
    default_colormap: xcb_colormap_t,
    white_pixel: u32,
    black_pixel: u32,
    current_input_masks: u32,
    width_in_pixels: u16,
    height_in_pixels: u16,
    width_in_millimeters: u16,
    height_in_millimeters: u16,
    min_installed_maps: u16,
    max_installed_maps: u16,
    root_visual: xcb_visualid_t,
    backing_stores: u8,
    save_unders: u8,
    root_depth: u8,
    allowed_depths_len: u8,
};
pub const xcb_void_cookie_t = extern struct {
    sequence: u32,
};

pub const xcb_atom_t = u32;
pub const xcb_intern_atom_cookie_t = extern struct {
    sequence: c_uint,
};
pub const xcb_intern_atom_reply_t = extern struct {
    response_type: u8,
    pad0: u8,
    sequence: u16,
    length: u32,
    atom: xcb_atom_t,
};

pub const xcb_timestamp_t = u32;
pub const xcb_key_press_event_t = extern struct {
    response_type: u8,
    detail: xcb_keycode_t,
    sequence: u16,
    time: xcb_timestamp_t,
    root: xcb_window_t,
    event: xcb_window_t,
    child: xcb_window_t,
    root_x: i16,
    root_y: i16,
    event_x: i16,
    event_y: i16,
    state: u16,
    same_screen: u8,
    pad0: u8,
};
pub const xcb_client_message_data_t = extern union {
    data8: [20]u8,
    data16: [10]u16,
    data32: [5]u32,
};
pub const xcb_client_message_event_t = extern struct {
    response_type: u8,
    format: u8,
    sequence: u16,
    window: xcb_window_t,
    type: xcb_atom_t,
    data: xcb_client_message_data_t,
};
pub const xcb_generic_event_t = extern struct {
    response_type: u8,
    pad0: u8,
    sequence: u16,
    pad: [7]u32,
    full_sequence: u32,
};

pub const xcb_button_t = u8;
pub const xcb_button_press_event_t = struct {
    response_type: u8,
    detail: xcb_button_t,
    sequence: u16,
    time: xcb_timestamp_t,
    root: xcb_window_t,
    event: xcb_window_t,
    child: xcb_window_t,
    root_x: i16,
    root_y: i16,
    event_x: i16,
    event_y: i16,
    state: u16,
    same_screen: u8,
    pad0: u8,
};
pub const xcb_button_release_event_t = xcb_button_press_event_t;

pub const XCB_CW_BACK_PIXMAP = 1;
pub const XCB_CW_BACK_PIXEL = 2;
pub const XCB_CW_BORDER_PIXMAP = 4;
pub const XCB_CW_BORDER_PIXEL = 8;
pub const XCB_CW_BIT_GRAVITY = 16;
pub const XCB_CW_WIN_GRAVITY = 32;
pub const XCB_CW_BACKING_STORE = 64;
pub const XCB_CW_BACKING_PLANES = 128;
pub const XCB_CW_BACKING_PIXEL = 256;
pub const XCB_CW_OVERRIDE_REDIRECT = 512;
pub const XCB_CW_SAVE_UNDER = 1024;
pub const XCB_CW_EVENT_MASK = 2048;
pub const XCB_CW_DONT_PROPAGATE = 4096;
pub const XCB_CW_COLORMAP = 8192;
pub const XCB_CW_CURSOR = 16384;
pub const XCB_EVENT_MASK_NO_EVENT = 0;
pub const XCB_EVENT_MASK_KEY_PRESS = 1;
pub const XCB_EVENT_MASK_KEY_RELEASE = 2;
pub const XCB_EVENT_MASK_BUTTON_PRESS = 4;
pub const XCB_EVENT_MASK_BUTTON_RELEASE = 8;
pub const XCB_EVENT_MASK_ENTER_WINDOW = 16;
pub const XCB_EVENT_MASK_LEAVE_WINDOW = 32;
pub const XCB_EVENT_MASK_POINTER_MOTION = 64;
pub const XCB_EVENT_MASK_POINTER_MOTION_HINT = 128;
pub const XCB_EVENT_MASK_BUTTON_1_MOTION = 256;
pub const XCB_EVENT_MASK_BUTTON_2_MOTION = 512;
pub const XCB_EVENT_MASK_BUTTON_3_MOTION = 1024;
pub const XCB_EVENT_MASK_BUTTON_4_MOTION = 2048;
pub const XCB_EVENT_MASK_BUTTON_5_MOTION = 4096;
pub const XCB_EVENT_MASK_BUTTON_MOTION = 8192;
pub const XCB_EVENT_MASK_KEYMAP_STATE = 16384;
pub const XCB_EVENT_MASK_EXPOSURE = 32768;
pub const XCB_EVENT_MASK_VISIBILITY_CHANGE = 65536;
pub const XCB_EVENT_MASK_STRUCTURE_NOTIFY = 131072;
pub const XCB_EVENT_MASK_RESIZE_REDIRECT = 262144;
pub const XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY = 524288;
pub const XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT = 1048576;
pub const XCB_EVENT_MASK_FOCUS_CHANGE = 2097152;
pub const XCB_EVENT_MASK_PROPERTY_CHANGE = 4194304;
pub const XCB_EVENT_MASK_COLOR_MAP_CHANGE = 8388608;
pub const XCB_EVENT_MASK_OWNER_GRAB_BUTTON = 16777216;
pub const XCB_COPY_FROM_PARENT = @as(c_long, 0);
pub const XCB_WINDOW_CLASS_COPY_FROM_PARENT = 0;
pub const XCB_WINDOW_CLASS_INPUT_OUTPUT = 1;
pub const XCB_WINDOW_CLASS_INPUT_ONLY = 2;
pub const XCB_PROP_MODE_REPLACE = 0;
pub const XCB_PROP_MODE_PREPEND = 1;
pub const XCB_PROP_MODE_APPEND = 2;

pub const XCB_ATOM_WM_NAME = 39;
pub const XCB_ATOM_STRING = 31;

// events we might use TODO: add more
pub const XCB_KEY_PRESS = @as(c_int, 2);
pub const XCB_KEY_RELEASE = @as(c_int, 3);
pub const XCB_CLIENT_MESSAGE = @as(c_int, 33);
pub const XCB_BUTTON_PRESS = @as(c_int, 4);
pub const XCB_BUTTON_RELEASE = @as(c_int, 5);
pub const XCB_MOTION_NOTIFY = @as(c_int, 6);
pub const XCB_CONFIGURE_NOTIFY = @as(c_int, 22);

pub extern fn XGetXCBConnection(dpy: *Display) *xcb_connection_t;
pub extern fn XOpenDisplay(?[*]u8) ?*Display;
pub extern fn xcb_connection_has_error(c: *xcb_connection_t) c_int;
pub extern fn XAutoRepeatOff(dpy: *Display) c_int;
pub extern fn XAutoRepeatOn(dpy: *Display) c_int;
pub extern fn xcb_get_setup(c: *xcb_connection_t) *xcb_setup_t;
pub extern fn xcb_setup_roots_iterator(R: *const xcb_setup_t) xcb_screen_iterator_t;
pub extern fn xcb_generate_id(c: *xcb_connection_t) u32;
pub extern fn xcb_create_window(c: *xcb_connection_t, depth: u8, wid: xcb_window_t, parent: xcb_window_t, x: i16, y: i16, width: u16, height: u16, border_width: u16, _class: u16, visual: xcb_visualid_t, value_mask: u32, value_list: ?*const c_void) xcb_void_cookie_t;
pub extern fn xcb_intern_atom_reply(c: *xcb_connection_t, cookie: xcb_intern_atom_cookie_t, e: ?*c_void) *xcb_intern_atom_reply_t;
pub extern fn xcb_intern_atom(c: *xcb_connection_t, only_if_exists: u8, name_len: u16, name: [*]const u8) xcb_intern_atom_cookie_t;
pub extern fn xcb_change_property(c: *xcb_connection_t, mode: u8, window: xcb_window_t, property: xcb_atom_t, type: xcb_atom_t, format: u8, data_len: u32, data: ?*const c_void) xcb_void_cookie_t;
pub extern fn xcb_map_window(c: *xcb_connection_t, window: xcb_window_t) xcb_void_cookie_t;
pub extern fn xcb_flush(c: *xcb_connection_t) c_int;
pub extern fn xcb_destroy_window(c: *xcb_connection_t, w: xcb_window_t) c_int; 
pub extern fn xcb_poll_for_event(c: *xcb_connection_t) ?*xcb_generic_event_t;
