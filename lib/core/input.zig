//! input events and tracking
const std = @import("std");

// TODO: add event sending

/// enum of all internal keycodes
pub const keys = enum(u16) {
    backspace = 0x08,
    enter = 0x0D,
    tab = 0x09,
    shift = 0x10,
    control = 0x11,

    pause = 0x13,
    capital = 0x14,

    escape= 0x1b,

    convert= 0x1c,
    nonconvert= 0x1d,
    accept= 0x1e,
    modechange= 0x1f,

    space = 0x20,
    prior = 0x21,
    next = 0x22,
    end = 0x23,
    home = 0x24,
    left = 0x25,
    up = 0x26,
    right = 0x27,
    down = 0x28,
    select = 0x29,
    print= 0x2a,
    execute= 0x2b,
    snapshot= 0x2c,
    insert= 0x2d,
    delete= 0x2e,
    help= 0x2f,

    a = 0x41,
    b = 0x42,
    c = 0x43,
    d = 0x44,
    e = 0x45,
    f = 0x46,
    g = 0x47,
    h = 0x48,
    i = 0x49,
    j= 0x4a,
    k= 0x4b,
    l= 0x4c,
    m= 0x4d,
    n= 0x4e,
    o= 0x4f,
    p = 0x50,
    q = 0x51,
    r = 0x52,
    s = 0x53,
    t = 0x54,
    u = 0x55,
    v = 0x56,
    w = 0x57,
    x = 0x58,
    y = 0x59,
    z= 0x5a,

    lwin= 0x5b,
    rwin= 0x5c,
    apps= 0x5d,

    sleep= 0x5f,

    numpad0 = 0x60,
    numpad1 = 0x61,
    numpad2 = 0x62,
    numpad3 = 0x63,
    numpad4 = 0x64,
    numpad5 = 0x65,
    numpad6 = 0x66,
    numpad7 = 0x67,
    numpad8 = 0x68,
    numpad9 = 0x69,
    multiply= 0x6a,
    add= 0x6b,
    separator= 0x6c,
    subtract= 0x6d,
    decimal= 0x6e,
    divide= 0x6f,
    f1 = 0x70,
    f2 = 0x71,
    f3 = 0x72,
    f4 = 0x73,
    f5 = 0x74,
    f6 = 0x75,
    f7 = 0x76,
    f8 = 0x77,
    f9 = 0x78,
    f10 = 0x79,
    f11= 0x7a,
    f12= 0x7b,
    f13= 0x7c,
    f14= 0x7d,
    f15= 0x7e,
    f16= 0x7f,
    f17 = 0x80,
    f18 = 0x81,
    f19 = 0x82,
    f20 = 0x83,
    f21 = 0x84,
    f22 = 0x85,
    f23 = 0x86,
    f24 = 0x87,

    numlock = 0x90,
    scroll = 0x91,

    numpad_equal = 0x92,

    lshift= 0xa0,
    rshift= 0xa1,
    lcontrol= 0xa2,
    rcontrol= 0xa3,
    lmenu= 0xa4,
    rmenu= 0xa5,

    semicolon= 0xba,
    plus = 0xbb,
    comma = 0xbc,
    minus = 0xbd,
    period = 0xbe,
    slash = 0xbf,
    grave = 0xc0,

    unknown = 0x00,
};

/// State of all keys
const keyboard_state = struct {
    keys: [256]bool = [_]bool{false} ** 256,
};

/// enum of mouse buttons
pub const mouse_btns = enum {
    left,
    right,
    middle,
    // todo: 
    other,
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
    keyboard_prev: keyboard_state = .{},
    keyboard_curr: keyboard_state = .{},
    mouse_prev: mouse_state = .{
        .buttons = [_]bool{false} **  @typeInfo(mouse_btns).Enum.fields.len,
    },
    mouse_curr: mouse_state = .{
        .buttons = [_]bool{false} **  @typeInfo(mouse_btns).Enum.fields.len,
    },
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

pub fn update(dt: f64) void {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return;
    }

    // copy state from current to prev
    state.keyboard_prev = state.keyboard_curr;
    state.mouse_prev = state.mouse_curr;
}

// keyboard stuff

/// is the given key down this frame
pub fn isKeyDown(k: keys) bool {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return false;
    }

    return state.keyboard_curr.keys[@enumToInt(k)] == true;
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

pub fn processKey(k: keys, pressed: bool) void {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return;
    }

    // if it has actually changed then change the state
    if (state.keyboard_curr.keys[@enumToInt(k)] != pressed) {
        state.keyboard_curr.keys[@enumToInt(k)] = pressed;
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
        .x = state.mouse_curr.x,
        .y = state.mouse_curr.y,
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
pub fn processMouseBtn(b: mouse_btns, pressed: bool) void {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return;
    }

    // if it has actually changed then change the state
    if (state.mouse_curr.buttons[@enumToInt(b)] != pressed) {
        state.mouse_curr.buttons[@enumToInt(b)] = pressed;
    }
}

/// change state based on mouse movement
pub fn processMouseMove(x: i16, y: i16) void {
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
pub fn processMouseWheel(delta: i8) void {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return;
    }

    state.mouse_curr.z_delata = detla;
}

//test "input" {
//
//}
