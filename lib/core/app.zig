const platform = @import("../platform/platform.zig");
pub const App = struct {
    runFn: fn () void,

    const Self = @This();

    pub fn init(self: *Self) !void {
        // start platform stuff
        try platform.init();
    }

    pub fn run(self: *Self) void {
        var quit = false;
        while (!quit) {
            // flush platform
            if (platform.flushMsg()) |event| {
                switch (event) {
                    .Quit => quit = true,
                }
            }
            //self.runFn();
        }
    }

    pub fn deinit(self: *Self) void {
        // shutdown platform stuff
        platform.deinit();
    }
};
