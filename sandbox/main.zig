const std = @import("std");
const engine = @import("engine");
const input = engine.input;

fn dummy() void {
    if (input.wasBtnUp(input.mouse_btns.middle) and input.isBtnDown(input.mouse_btns.middle)) {
        std.log.info("hehe", .{});
    }

    //std.log.info("mouse x: {} y: {}", input.getMousePosition());
}

pub fn main() anyerror!void {
    var app: engine.App = .{
        .runFn = dummy,
    };
    try app.init();
    defer app.deinit();
    app.run();
}
