const std = @import("std");
const testing = std.testing;

const max_components = 1000;

const EntityId = usize;
// id 0 is reserved for no entity
const nullEntity: EntityID = 0;

pub fn ComponentStore(
    comptime T: type,
) type {
    return struct {

        allocator: *std.mem.Allocator,
        // TODO: should this reallocate?
        items:  []align(1)T,

        idToIndex: [max_components]usize,
        indexToId: [max_components]usize,

        const Self = @This();

        pub fn init(allocator: *std.mem.Allocator) !Self {
            return Self {
                .allocator = allocator,
                .items = try allocator.alloc(T, max_components * @sizeOf(T)),
            };
        }

        /// Add a component 
        /// replaces component if it already exists
        pub fn add(c: T, id: usize) !void {
            if (id > max_components) 
                return error.InvalidId;
            // add it
            items[indexToId] = c;
        }

        /// Remove component 
        pub fn remove(id: usize) !void {

        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.items.ptr[0..max_components]);
        }

    };
}

//const Registry = struct {
//    pub fn addComponent(T: type, c: anytype) !void {
//
//    }
//};
