const std = @import("std");

/// window geometry
pub const Geom = struct {
    x: i16,
    y: i16,
    w: u16,
    h: u16,
};
const Window = @This();

/// Cross platform way of refering to this window
id: usize,
resizeFn: fn (*Window, Geom) void,

/// resize the window, given the new geometry
pub fn resize(self: *Window, geom: Geom) void {
    return self.resizeFn(self, geom);
}
