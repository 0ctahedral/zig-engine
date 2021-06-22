const std = @import("std");
pub const Window = @import("window.zig");
const Geom = @import("window.zig").Geom;
const Event = @import("event.zig").Event;

const Allocator = std.mem.Allocator;

//TODO: change this at compile time to each platform
const backend = @import("linux" ++ "/platform.zig");

pub const allocator = backend.allocator;

pub fn init() anyerror!void {
    return backend.init();
}

pub fn deinit() void {
    return backend.deinit();
}

/// Poll for events from the platform
//pub fn flushMsg() ?Event {
pub fn flushMsg() void {
    return backend.flushMsg();
}

pub fn createWindow(
    title: []const u8,
    geom: Geom,
) anyerror!*Window {
    return backend.createWindow(title, geom);
}

pub fn shouldQuit() bool {
    return backend.shouldQuit();
}

pub fn destroyWindow(window: *Window) void {
    return backend.destroyWindow(window);
}
