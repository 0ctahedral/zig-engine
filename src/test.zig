const std = @import("std");
const engine = @import("engine");

fn dummy() void {
//    std.log.info("hehe", .{});
}

pub fn main() anyerror!void {
    var app: engine.App = .{
        .runFn = dummy,
    };
    try app.init();
    defer app.deinit();
    app.run();
}
