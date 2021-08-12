const std = @import("std");
const ecs = @import("ecs.zig");
const testing = std.testing;

const vec3 = struct {
    x: f32 = 0,
    y: f32 = 0,
    z: f32 = 0,
};

test "component store" {
    var vec_store = try ecs.ComponentStore(vec3).init(std.testing.allocator);
    defer vec_store.deinit();
}

test "add component" {
    var vec_store = try ecs.ComponentStore(vec3).init(std.testing.allocator);
    defer vec_store.deinit();

    try vec_store.add(@as(usize, 3), .{.x=1, .y=2, .z=3});

    // id should increase
    try testing.expect(vec_store.next_idx == 1);
    // first index should be 0
    try testing.expect(vec_store.indexToId[0] == 3);
    try testing.expect(vec_store.idToIndex[3] == 0);

    // test adding another
    try vec_store.add(@as(usize, 2), .{.x=4, .y=5, .z=6});
    try testing.expect(vec_store.next_idx == 2);
    try testing.expect(vec_store.idToIndex[2] == 1);
    try testing.expect(vec_store.indexToId[1] == 2);

    // shouldn't be able to do null entity
    try testing.expectError(error.InvalidId, vec_store.add(@as(usize, 0), .{}));
}

test "remove component" {
    var vec_store = try ecs.ComponentStore(vec3).init(std.testing.allocator);
    defer vec_store.deinit();

    // can't do anything with a null entity
    try testing.expectError(error.InvalidId, vec_store.remove(@as(usize, 0)));

    // can't remove from entity without component
    try testing.expectError(error.NoComponent, vec_store.remove(@as(usize, 2)));

    // add a few
    try vec_store.add(@as(usize, 1), .{.x=1, .y=2, .z=3});
    try vec_store.add(@as(usize, 2), .{.x=1, .y=2, .z=3});
    try vec_store.add(@as(usize, 3), .{.x=1, .y=2, .z=3});

    // remove the first one
    try vec_store.remove(@as(usize, 1));
    // this means that the index should move the last index back
    // and that the indicies should have been swapped
    // | 1 | 2 | 3 | tmp = 3
    // | _ | 2 | 3 | [0] = tmp
    // | 3 | 2 | _ | clear 3
    //try testing.expect(vec_store.idToIndex[1] == 0);
    //try testing.expect(vec_store.idToIndex[2] == 2);
    //try testing.expect(vec_store.idToIndex[3] == 1);
}
