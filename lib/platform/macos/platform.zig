const std = @import("std");
const Window = @import("../window.zig").Window;
const Event = @import("../event.zig").Event;

pub const allocator = std.heap.page_allocator;

pub fn init() anyerror!void {
    std.log.info("macos startup", .{});
}

pub fn deinit() void {
    std.log.info("macos shutdown", .{});
}

pub fn flushMsg() ?Event {
    std.log.info("macos flush", .{});
    return null;
}

pub fn createWindow() anyerror!Window {
    std.log.info("macos create window", .{});
    return Window{};
}
