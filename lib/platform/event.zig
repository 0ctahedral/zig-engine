const std = @import("std");
pub const Event = enum {
    WindowClose,
    KeyPress,
    KeyRelease,
};
