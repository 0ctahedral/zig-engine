
const Platform = @This();
//    comptime struct {
//        comptime state: State,
//    }
pub fn Platform(
    /// Allocator we are going to use for everything in the engine.
    /// TODO: custom allocator
    allocator: *Allocator,

    /// Internal type
    internal: type,

    /// shutdown the platform
    startupFn: comptime fn([]const u8, i32, i32, u32, u32,) !void,
    shutDownFn: comptime fn(*Platform) void,
    getTimeFn: comptime fn(*Platform) f64,
    sleepFn: fn sleep(self: *Platform, ms: u64) void,
) type {
    return struct {
        allocator: allocator,

        fn startup(
            self: *Platform,
            app_name: []const u8,
            x: i32,
            y: i32,
            width: u32,
            height: u32,
        ) !void {
            try startupFn(self, app_name, x, y, width, height);
        }

        fn shutDown(self: *Platform) void {
            shutdownFn(self);
        }

        fn createWindow() window {

        }

        /// Get absolute time
        fn getTime(self: *Platform) f64 {
            return getTimeFn(self);
        }

        /// sleep
        fn sleep(self: *Platform, ms: u64) void {
            sleepFn(self, ms);
        }
    };
}
