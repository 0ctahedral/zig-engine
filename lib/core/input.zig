//! input events and tracking
const std = @import("std");
const event = @import("event.zig");

// TODO: add event sending

/// enum of all internal keycodes
pub const keys = enum(u16) {
    unknown = 0,

    space = 32,
    apostrophe = 39,
    comma = 44,
    minus = 45,
    period = 46,
    slash = 47,
    semicolon = 59,
    equal = 61,
    a = 65,
    b = 66,
    c = 67,
    d = 68,
    e = 69,
    f = 70,
    g = 71,
    h = 72,
    i = 73,
    j = 74,
    k = 75,
    l = 76,
    m = 77,
    n = 78,
    o = 79,
    p = 80,
    q = 81,
    r = 82,
    s = 83,
    t = 84,
    u = 85,
    v = 86,
    w = 87,
    x = 88,
    y = 89,
    z = 90,
    left_bracket = 91,
    backslash = 92,
    right_bracket = 93,
    grave = 96,
    world_1 = 161, // non-US #1
    world_2 = 162, // non-US #2

    // Function keys
    escape = 256,
    enter = 257,
    tab = 258,
    backspace = 259,
    insert = 260,
    delete = 261,
    right = 262,
    left = 263,
    down = 264,
    up = 265,
    page_up = 266,
    page_down = 267,
    home = 268,
    end = 269,
    caps_lock = 280,
    scroll_lock = 281,
    num_lock = 282,
    print= 283,
    pause = 284,
    f1 = 290,
    f2 = 291,
    f3 = 292,
    f4 = 293,
    f5 = 294,
    f6 = 295,
    f7 = 296,
    f8 = 297,
    f9 = 298,
    f10 = 299,
    f11 = 300,
    f12 = 301,
    f13 = 302,
    f14 = 303,
    f15 = 304,
    f16 = 305,
    f17 = 306,
    f18 = 307,
    f19 = 308,
    f20 = 309,
    f21 = 310,
    f22 = 311,
    f23 = 312,
    f24 = 313,
    f25 = 314,
    n0 = 320,
    n1 = 321,
    n2 = 322,
    n3 = 323,
    n4 = 324,
    n5 = 325,
    n6 = 326,
    n7 = 327,
    n8 = 328,
    n9 = 329,
    decimal = 330,
    divide = 331,
    multiply = 332,
    subtract = 333,
    add = 334,
    l_shift = 340,
    l_control = 341,
    l_alt = 342,
    l_super = 343,
    r_shift = 344,
    r_control = 345,
    r_alt = 346,
    r_super = 347,
    menu = 348,
};

/// State of all keys
const keyboard_state = struct {
    keys: [348]bool = [_]bool{false} ** 348,
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

pub fn processKey(k: keys, pressed: bool) !void {
    if (!initialized) {
        std.log.err("input not initialized", .{});
        return;
    }

    // if it has actually changed then change the state
    if (state.keyboard_curr.keys[@enumToInt(k)] != pressed) {
        state.keyboard_curr.keys[@enumToInt(k)] = pressed;
        // send event
        const ev= if (pressed) event.Event{.KeyPress=k}
        else event.Event{.KeyRelease=k};
        try event.send(ev);
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
