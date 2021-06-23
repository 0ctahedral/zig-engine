const std = @import("std");
const os = std.os;

const Window = @import("../window.zig");
const LinuxWindow = @import("window.zig").LinuxWindow;
const Geom = @import("../window.zig").Geom;
const Event = @import("../../core/event.zig").Event;

usingnamespace @import("xcb_decls.zig");

pub const allocator = std.heap.page_allocator;

var display: *Display = undefined;
var connection: *xcb_connection_t = undefined;
var screen: *xcb_screen_t = undefined;

// TODO: turn this into ringbuffer
var windows: []?LinuxWindow = undefined;
/// idx of last window
var widx: usize = 0;
//var window_mask: u8 = 0;
var living_windows: usize = 0;

var quit = false;

pub fn shouldQuit() bool {
    return quit;
}

pub fn init() anyerror!void {
    std.log.info("linux startup", .{});

    display = XOpenDisplay(null).?;
    _ = XAutoRepeatOff(display);
    connection = XGetXCBConnection(display);
    if (xcb_connection_has_error(connection) != 0) {
        return error.XcbConnectionFail;
    }
    var itr: xcb_screen_iterator_t = xcb_setup_roots_iterator(xcb_get_setup(connection));
    // Use the last screen
    screen = @ptrCast(*xcb_screen_t, itr.data);


    var act = os.Sigaction{
        .handler = .{ .sigaction = handler },
        .mask = os.empty_sigset,
        .flags = (os.SA_SIGINFO | os.SA_RESETHAND),
    };
    os.sigaction(os.SIGINT, &act, null);

    windows = try allocator.alloc(?LinuxWindow, 5);
}

fn handler(sig: i32, info: *const os.siginfo_t, ctx_ptr: ?*const c_void) callconv(.C) void {
    // TODO: send the quit message and get rid of the platform should quit check
    if (sig == os.SIGINT) {
        quit = true;
    }
}

pub fn deinit() void {
    _ = XAutoRepeatOn(display);
    allocator.free(windows);
    std.log.info("linux shutdown", .{});
}

pub fn flushMsg() ?Event {
    var i: usize = 0;
    var ret: ?Event = null;
    if (xcb_poll_for_event(connection)) |event| {
        // Input events
        switch (event.*.response_type & ~@as(u32, 0x80)) {
            XCB_KEY_PRESS => {
                const kev = @ptrCast(*xcb_key_press_event_t, event);
                ret = Event.KeyPress;
            },
            XCB_KEY_RELEASE => {
                const kev = @ptrCast(*xcb_key_press_event_t, event);
                ret = Event.KeyRelease;
            },
            XCB_CLIENT_MESSAGE => {
                const cm = @ptrCast(*xcb_client_message_event_t, event);
                // Window close
                // search through windows to find which one it is equal to
                for (windows) |win| {
                    if (win != null and
                        cm.*.data.data32[0] == win.?.wm_del and 
                        cm.window == win.?.window
                        ) {
                        ret = Event{.WindowClose = cm.window };
                        destroyWindow(&win.?.parent);
                    }
                }
            },
            XCB_BUTTON_PRESS => {},
            XCB_BUTTON_RELEASE => {},
            XCB_MOTION_NOTIFY => {},
            // for resizes
            XCB_CONFIGURE_NOTIFY => {},
            //else => |ev| std.log.info("event: {}", .{ev}),
            else => {},
        }
        _ = xcb_flush(connection);
    }
    return null;
}

pub fn destroyWindow(window: *const Window) void {
    // get the id of the linux window
    std.log.info("there are {} windows. destroying {}", .{living_windows, window.id});

    // if this window is null then we've already taken care of it
    if (windows[window.id] == null) {
        return;
    }

    var i: usize = 0;
    while (i < windows.len) : (i+=1) {
        // compare to all our windows
        if (window.id == i) {
            // if we are about to destroy the last window then  turn autorepeat back on
            if (living_windows == 1) {
                _ = XAutoRepeatOn(display);
            }
            _ = xcb_destroy_window(connection, windows[window.id].?.window);
            living_windows -= 1;
            // remove from windows list
            windows[window.id] = null;
            return;
        }
    }
}

pub fn createWindow(
    title: []const u8,
    geom: Geom,
) anyerror!*Window {
    if ((widx + 1) > windows.len) {
        return error.TooManyWindows;
    }

    // fill that sucker in
    windows[widx] = try LinuxWindow.init(widx, connection, screen, title, geom);
    widx += 1;
    living_windows += 1;

    return &windows[widx-1].?.parent;
}
