const std = @import("std");

const max_components = 1000;

const EntityId = usize;
// id 0 is reserved for no entity
const nullEntity: EntityID = 0;

// start
// indicies 0 1 2 3 4 5 6 7 8 9 
// slots   |_|_|_|_|_|_|_|_|_|_|
// ids     |0|1|2|3|4|5|6|7|8|9|
// ptr      ^
// add(id = 3)
// indicies 0 1 2 3 4 5 6 7 8 9 
// slots   |C|_|_|_|_|_|_|_|_|_|
// ids     |3|1|2|0|4|5|6|7|8|9|
// ptr        ^
// add(id = 2)
// indicies 0 1 2 3 4 5 6 7 8 9 
// slots   |C|C|_|_|_|_|_|_|_|_|
// ids     |3|2|1|0|4|5|6|7|8|9|
// ptr          ^
// add(id = 4)
// indicies 0 1 2 3 4 5 6 7 8 9 
// slots   |C|C|C|_|_|_|_|_|_|_|
// ids     |3|2|4|0|1|5|6|7|8|9|
// ptr            ^

pub fn ComponentStore(
    comptime T: type,
) type {
    return struct {

        allocator: *std.mem.Allocator,
        // TODO: should this reallocate?
        items:  []T,

        idToIndex: []usize,
        indexToId: []usize,

        next_idx: usize = 0,

        const Self = @This();

        /// Create the store
        pub fn init(allocator: *std.mem.Allocator) !Self {
            var ret = Self {
                .allocator = allocator,
                .items = try allocator.alloc(T, max_components),
                .idToIndex = try allocator.alloc(usize, max_components),
                .indexToId = try allocator.alloc(usize, max_components),
            };

            std.mem.set(T, ret.items, .{});
            std.mem.set(usize, ret.idToIndex, 0);
            std.mem.set(usize, ret.indexToId, 0);

            return ret;
        }

        /// Add a component 
        /// replaces component if it already exists
        pub fn add(self: *Self, id: usize, c: T) !void {
            if (id > max_components or id < 1) 
                return error.InvalidId;

            const index = self.idToIndex[id];

            // we already have this entity, replacing
            if (index > 0) {
                self.items[index] = c;
                return;
            }
            // put em in at the end
            self.indexToId[self.next_idx] = id;
            self.idToIndex[id] = self.next_idx;

            self.next_idx += 1;
        }

        /// Remove component 
        pub fn remove(self: *Self, id: usize) !void {
            if (id > max_components or id < 1) 
                return error.InvalidId;

            // do we have a component
            const index = self.idToIndex[id];

            // we already have this entity, replacing
            if (index < 1) {
                return error.NoComponent;
            }

            self.next_idx -= 1;
            // take value from the last idx and switch em
            self.items[index] = self.items[self.next_idx];
            // id of last item in array
            const l_id = self.indexToId[self.next_idx];
            // set new index
            self.idToIndex[l_id] = index;

            // clear
            self.idToIndex[id] = 0;
            self.indexToId[self.next_idx] = 0;
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.items);
            self.allocator.free(self.idToIndex);
            self.allocator.free(self.indexToId);
        }

    };
}

//const Registry = struct {
//    pub fn addComponent(T: type, c: anytype) !void {
//
//    }
//};
