const Platform = @import("platform.zig").Platform;

pub const Linux = Plaform(

);

fn startup(
    platform: *Platform,
    app_name: []const u8,
    x: i32,
    y: i32,
    width: u32,
    height: u32,
) !void {

}

fn shutdown(platform: *Platform) void {

}

fn getTime(platform: *Platform) f64 {

}

fn sleep(platform: *Platform, ms) void {

}
