const std = @import("std");
const engine = @import("engine");

fn dummy() void {
    std.log.info("hehe", .{});
}

//extern fn createApplication() engine.app.App;
fn createApplication() engine.App {
    return .{
        .runFn = dummy,
    };
}

pub fn main() anyerror!void {
    var app = createApplication();
    try app.init();
    defer app.deinit();

    app.run();
}
