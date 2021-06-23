const std = @import("std");
const Window = @import("../window.zig");
const Geom = @import("../window.zig").Geom;
usingnamespace @import("xcb_decls.zig");

pub const LinuxWindow = struct {
    /// the window object we are using
    parent: Window, 
    /// connection to the x server
    connection: *xcb_connection_t = undefined,
    /// the xcb handle for this window
    window: xcb_window_t = undefined,
    /// x11 wm atom for this window
    wm_proto: xcb_atom_t = undefined,
    /// x11 delete atom for this window
    wm_del: xcb_atom_t = undefined,

    id: usize,

    const Self = @This();

    /// Creates a new linux window
    pub fn init(widx: usize, connection: *xcb_connection_t, screen: *xcb_screen_t, title: []const u8, geom: Geom) !Self {

        // Allocate an id for our window
        const window = xcb_generate_id(connection);

        // We are setting the background pixel color and the event mask
        const mask: u32  = XCB_CW_BACK_PIXEL | XCB_CW_EVENT_MASK;

        // background color and events to request
        const values = [_]u32 {screen.*.black_pixel, XCB_EVENT_MASK_BUTTON_PRESS | XCB_EVENT_MASK_BUTTON_RELEASE |
            XCB_EVENT_MASK_KEY_PRESS | XCB_EVENT_MASK_KEY_RELEASE |
                XCB_EVENT_MASK_EXPOSURE | XCB_EVENT_MASK_POINTER_MOTION |
                XCB_EVENT_MASK_STRUCTURE_NOTIFY};

        // Create the window
        const cookie: xcb_void_cookie_t = xcb_create_window(
            connection,
            XCB_COPY_FROM_PARENT,
            window,
            screen.*.root,
            geom.x,
            geom.y,
            geom.w,
            geom.h,
            0,
            XCB_WINDOW_CLASS_INPUT_OUTPUT,
            screen.*.root_visual,
            mask,
            values[0..]);

        // Notify us when the window manager wants to delete the window
        const datomname = "WM_DELETE_WINDOW";
        const wm_delete_reply = xcb_intern_atom_reply(
            connection,
            xcb_intern_atom(
                connection,
                0,
                datomname.len,
                datomname),
            null);
        const patomname = "WM_PROTOCOLS";
        const wm_protocols_reply = xcb_intern_atom_reply(
            connection,
            xcb_intern_atom(
                connection,
                0,
                patomname.len,
                patomname),
            null);

        //// store the atoms
        var wm_del = wm_delete_reply.*.atom;
        var wm_proto = wm_protocols_reply.*.atom;

        // ask the sever to actually set the atom
        _ = xcb_change_property(
            connection,
            XCB_PROP_MODE_REPLACE,
            window,
            wm_proto,
            4,
            32,
            1,
            &wm_del);
        
        // change the name

        _ = xcb_change_property(
            connection,
            XCB_PROP_MODE_REPLACE,
            window,
            XCB_ATOM_WM_NAME,
            XCB_ATOM_STRING,
            8,  // data should be viewed 8 bits at a time
            @intCast(u32, title.len),
            title.ptr
        );

        // Map the window to the screen
        _ = xcb_map_window(connection, window);

        if (xcb_flush(connection) <= 0) {
            return error.xcbFlushError;
        }

        std.log.info("linux create window # {}", .{window});
        return Self{
            .connection = connection,
            .window = window,
            .id = widx,
            .wm_del = wm_del,
            .wm_proto = wm_proto,
            .parent = .{
                .id = widx,
                .resizeFn = resize,
            },

        };
    }

    fn resize(window: *Window, geom: Geom) void {
        const self = @fieldParentPtr(Self, "parent", window);
    }
};
