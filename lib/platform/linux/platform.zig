const std = @import("std");
const os = std.os;

const Window = @import("../window.zig");
const LinuxWindow = @import("window.zig").LinuxWindow;
const Geom = @import("../window.zig").Geom;
const Event = @import("../event.zig").Event;

usingnamespace @import("xcb_decls.zig");

pub const allocator = std.heap.page_allocator;

var display: *Display = undefined;
var connection: *xcb_connection_t = undefined;
var screen: *xcb_screen_t = undefined;

// TODO: turn this into ringbuffer
var windows: []LinuxWindow = undefined;
/// idx of last window
var widx: usize = 0;
var livingWindows: usize = 0;

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
        //.flags = (os.SA_SIGINFO | os.SA_RESETHAND),
        .flags = (os.SA_SIGINFO | os.SA_RESETHAND),
    };
    os.sigaction(os.SIGINT, &act, null);

    windows = try allocator.alloc(LinuxWindow, 5);
}

fn handler(sig: i32, info: *const os.siginfo_t, ctx_ptr: ?*const c_void) callconv(.C) void {
    if (sig == os.SIGINT) {
        quit = true;
        std.debug.warn("\nShutting down...\n", .{});
    }
}

pub fn deinit() void {
    _ = XAutoRepeatOn(display);
    allocator.free(windows);
    std.log.info("linux shutdown", .{});
}

//pub fn flushMsg() ?Event {
pub fn flushMsg() void {
    // TODO: flush events from all windows
    // TODO: Limit number of events proccessed per frame
    //return null;
}

pub fn destroyWindow(window: *Window) void {
    // get the id of the linux window
    std.log.info("there are {} windows. destroying {}", .{widx, window.id});
    for (windows) |w| {
        // compare to all our windows
        if (window.id == w.id) {
            // if we are about to destroy the last window then  turn autorepeat back on
            if (livingWindows == 1) {
                std.log.info("about to destroy last window", .{});
                _ = XAutoRepeatOn(display);
            }
            _ = xcb_destroy_window(connection, w.window);
            livingWindows -= 1;
            return;
        }
    }
    // remove from windows list
    // or will that invalidate a pointer?
}

pub fn createWindow(
    title: []const u8,
    geom: Geom,
) anyerror!*Window {
    if ((widx + 1) > windows.len) {
        return error.TooManyWindows;
    }

    std.log.info("linux create window", .{});
    // fill that sucker in
    windows[widx] = try LinuxWindow.init(widx, connection, screen, title, geom);
    widx += 1;
    livingWindows += 1;

    return &windows[widx-1].parent;
}
