//! input events and tracking

// TODO: add event sending

/// enum of all internal keycodes
pub const keys = enum {

};

/// State of all keys
const keymap = struct {};

/// enum of mouse buttons
pub const mouse_btns = enum {
    left,
    right,
    middle,
};

// TODO: add controller

/// mouse state
const mouse_state = struct {
    x: i16 = 0,
    y: i16 = 0,
    z_delata: i8 = 0,
    buttons: [@typeInfo(mouse_btns).Enum.fields.len]bool,
};

const input_state = struct {
    keyboard_prev: keymap = .{},
    keyboard_curr: keymap = .{},
    mouse_prev: mouse_state = .{},
    mouse_curr: mouse_state = .{},
};

var initialized = false;
var state = input_state{};

/// Start the input subsystem
pub fn init() !void {
    initialized = true;
}

/// Shutdown the input subsystem
pub fn deinit() void {
    initialized = false;
}

pub fn update() void {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return;
    }

    // copy state from current to prev
}

// keyboard stuff

/// is the given key down this frame
pub fn isKeyDown(k: keys) bool {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return false;
    }

    return state.keyboard_curr[@enumToInt(k)] == true;
}

/// is the given key up this frame
pub fn isKeyUp(k: keys) bool {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return false;
    }

    return state.keyboard_curr[@enumToInt(k)] == false;
}

/// was the given key down last frame
pub fn wasKeyDown(k: keys) bool {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return false;
    }

    return state.keyboard_prev[@enumToInt(k)] == true;
}

/// was the given key up last frame
pub fn wasKeyUp(k: keys) bool {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return false;
    }

    return state.keyboard_prev[@enumToInt(k)] == false;
}

fn processKey(k: keys, pressed: bool) void {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return;
    }

    // if it has actually changed then change the state
    if (state.keyboard_curr[@enumToInt(k)] != pressed) {
        state.keyboard_curr[@enumToInt(k)] = pressed;
    }
}

// mouse stuff 

/// is the given button down this frame
pub fn isBtnDown(b: mouse_btns) bool {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return false;
    }

    return state.mouse_curr.buttons[@enumToInt(b)] == true;
}

/// is the given button up this frame
pub fn isBtnUp(b: mouse_btns) bool {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return false;
    }

    return state.mouse_curr.buttons[@enumToInt(b)] == false;
}

/// was the given button down last frame
pub fn wasBtnDown(b: mouse_btns) bool {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return false;
    }

    return state.mouse_prev.buttons[@enumToInt(b)] == true;
}

/// was the given button up last frame
pub fn wasBtnUp(b: mouse_btns) bool {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return false;
    }

    return state.mouse_prev.buttons[@enumToInt(b)] == false;
}

/// get the current mouse position
pub fn getMousePosition() struct {x: i32, y:i32} {
    return .{
        state.mouse_curr.x,
        state.mouse_curr.y,
    };
}

/// get the previous mouse position
pub fn getMousePrevPosition() struct {x: i32, y:i32} {
    return .{
        state.mouse_prev.x,
        state.mouse_prev.y,
    };
}

/// change state based on mouse button pressed
fn processMouseBtn(b: mouse_btns, pressed: bool) void {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return;
    }

    // if it has actually changed then change the state
    if (state.mouse_curr[@enumToInt(b)] != pressed) {
        state.mouse_curr[@enumToInt(b)] = pressed;
    }
}

/// change state based on mouse movement
fn processMouseMove(x: i16, y: i16) void {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return;
    }

    if (state.mouse_curr.x != x or state.mouse_curr.y != y) {
        state.mouse_curr.x = x;
        state.mouse_curr.y = y;
    }
}

/// change the state based on mousewheel movement
fn processMouseWheel(delta: i8) void {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return;
    }

    state.mouse_curr.z_delata = detla;
}

//test "input" {
//
//}
