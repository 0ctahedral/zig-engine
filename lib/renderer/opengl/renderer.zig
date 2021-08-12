const std = @import("std");
/// Initialize the renderer backend
pub fn init() !void {

}

/// Shutdown the renderer
pub fn deinit() void {
}

/// Setup the renderer to start rendering a new frame
pub fn beginFrame(dt: f32) !void {
    
}

/// Tell the renderer we are done with the current frame
pub fn endFrame(dt: f32) !void {

}

/// Submit data to the renderer for rendering
pub fn submit(packet: *render_packet) !void {

}

/// Tell the renderer that we have resized the window
pub fn onResize(w: u16, h: u16) !void {

}
