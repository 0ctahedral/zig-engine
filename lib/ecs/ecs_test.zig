const std = @import("std");
const ecs = @import("ecs.zig");
const testing = std.testing;

const vec3 = struct {
    x: f32,
    y: f32,
    z: f32,
};

test "component store" {
    var cs = try ecs.ComponentStore(vec3).init(std.heap.page_allocator);
    defer cs.deinit();
}
