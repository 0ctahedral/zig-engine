//! This is the renderer front end

//TODO: change this at compile time to each platform
const backend = @import("dummy" ++ "/renderer.zig");

/// Initialize the renderer backend
pub fn init() !void {
    return backend.init();
}

/// Shutdown the renderer
pub fn deinit() void {
    return backend.deinit();
}

/// Setup the renderer to start rendering a new frame
pub fn beginFrame(dt: f32) !void {
    return backend.beginFrame(dt);
}

/// Tell the renderer we are done with the current frame
pub fn endFrame(dt: f32) !void {
    return backend.endFrame(dt);
}

/// Submit data to the renderer for rendering
pub fn submit(packet: *render_packet) !void {
    return backend.submit(packet);
}

/// Tell the renderer that we have resized the window
pub fn onResize(w: u16, h: u16) !void {
    return backend.onResize(w, h);
}
