const std = @import("std");
const Window = @import("window.zig").Window;
const Event = @import("event.zig").Event;

const Allocator = std.mem.Allocator;

//TODO: change this at compile time to each platform
const backend = @import("linux" ++ "/platform.zig");

const allocator = backend.allocator;

pub fn init() anyerror!void {
    return backend.init();
}

pub fn deinit() void {
    return backend.deinit();
}

/// Poll for events from the platform
pub fn flushMsg() ?Event {
    return backend.flushMsg();
}

pub fn createWindow() anyerror!Window {
    return backend.createWin();
}
