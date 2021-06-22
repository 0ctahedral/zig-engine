const std = @import("std");
const Event = @import("event.zig").Event;

pub const Geom = struct {
    x: i16,
    y: i16,
    w: u16,
    h: u16,
};
const Window = @This();

id: usize,
flushFn: fn (*Window) ?Event,
deinitFn: fn (*Window) void,

pub fn flush(self: *Window) ?Event {
    return self.flushFn(self);
}

//pub fn deinit(self: *Window) void {
//    self.deinitFn(self);
//}
