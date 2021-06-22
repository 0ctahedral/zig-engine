const std = @import("std");
const Window = @import("../window.zig").Window;
const Event = @import("../event.zig").Event;

pub const allocator = std.heap.page_allocator;

pub fn init() anyerror!void {
    std.log.info("linux startup", .{});
}

pub fn deinit() void {
    std.log.info("linux shutdown", .{});
}

pub fn flushMsg() ?Event {
    std.log.info("linux flush", .{});
    return null;
}

pub fn createWindow() anyerror!Window {
    std.log.info("linux create window", .{});
    return Window{};
}
