pub const App = struct {
    runFn: fn () void,

    const Self = @This();

    pub fn init(self: *Self) !void {
        // start platform stuff
    }

    pub fn run(self: *Self) void {
        var quit = false;
        while (!quit) {
            // flush platform
            self.runFn();
        }
    }

    pub fn deinit(self: *Self) void {
        // shutdown platform stuff
    }
};
