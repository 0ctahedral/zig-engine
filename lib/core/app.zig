const std = @import("std");
const platform = @import("../platform/platform.zig");
const input = @import("input.zig");
const event = @import("event.zig");
const renderer = @import("../renderer/renderer.zig");

pub const App = struct {
    runFn: fn () void,

    state: struct {
        is_running: bool = true,
        is_suspended: bool = false,
        last_time: f64 = 0,
    } = .{},

    windows: std.ArrayList(*platform.Window) = undefined,

    const Self = @This();

    pub fn init(self: *Self) !void {
        // start platform stuff
        try platform.init();
        event.init(platform.allocator);
        try input.init();
        // window things
        self.windows = std.ArrayList(*platform.Window).init(platform.allocator);
        try self.windows.append(try platform.createWindow("title1", .{.x=100, .y=100, .w=200, .h=200}));
        try self.windows.append(try platform.createWindow("title2", .{.x=100, .y=100, .w=200, .h=200}));

        try event.register(event.EventType.Quit, self, quit);

        try renderer.init();
    }

    fn quit(self: *Self, e: event.Event) void {
        std.log.info("recieved quit event!", .{});
        self.state.is_running = false;
    }

    // TODO: suspend and stopped states

    pub fn run(self: *Self) void {
        while (self.state.is_running) {
            // TODO: add to message queue
            // get input from the os no matter what
            platform.flushMsg() catch |err| {
                std.log.err("{}", .{err});
            };
            // if we are suspended don't do anything else
            if (!self.state.is_suspended) {
                // frame start time

                self.runFn();
                
                // update input last

                // frame end time
                // time elapsed
                // give time back to os

                input.update(0);
                // update app time
            }
            //self.state.is_running = !platform.shouldQuit();
        }
    }

    pub fn deinit(self: *Self) void {
        renderer.deinit();
        event.deinit();
        input.deinit();
        // shutdown platform stuff
        for (self.windows.items) |win| {
            platform.destroyWindow(win);
        }
        self.windows.deinit();
        platform.deinit();
    }
};
