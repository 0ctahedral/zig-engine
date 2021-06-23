const std = @import("std");
pub const Event = union(enum) {
    WindowClose: usize,
    KeyPress,
    KeyRelease,
};
