//! Event subsystem
//! Any callback registered to recieve events is uniquely identified by the
//! specific event and the funciton and object pointers.
//! This means the same object can register for multiple events,
//! and that multiple objects of the same type can register for the same event
//! with the same function.
const std = @import("std");
const testing = std.testing;
const input = @import("input.zig");

var initialized = false;

pub const EventType = enum {
    Quit,
    WindowClose,
    KeyPress,
    KeyRelease,
    MousePress,
    MouseRelease,
    MouseMoved,
};

pub const Event = union(EventType) {
    Quit,
    WindowClose: usize,
    KeyPress: input.keys,
    KeyRelease: input.keys,
    MousePress: input.mouse_btns,
    MouseRelease: input.mouse_btns,
    MouseMoved: struct {x: i16, y: i16},
};

/// number of events
const nEvents = @typeInfo(EventType).Enum.fields.len;

/// helper to be less verbose
const opaqueT = *opaque{};
/// helper to be less verbose
const opaquefn = fn(opaqueT, Event)void;

/// a wrapper for a function and object to send
const Callback = struct {
    obj: opaqueT,
    func: opaquefn,
};

/// Where we store our different callbacks for different event types
var Callbacks: [nEvents]std.ArrayList(Callback) = undefined;

/// initialize the event subsystem
pub fn init(allocator: *std.mem.Allocator) void {
    initialized = true;

    var i: usize = 0;
    while (i < nEvents) : (i+=1) {
        Callbacks[i] = std.ArrayList(Callback).init(allocator);
    }
}

/// shutdown the event subsystem
pub fn deinit() void {
    initialized = false;
    var i: usize = 0;
    while (i < nEvents) : (i+=1) {
        Callbacks[i].deinit();
    }
}

/// Register a callback for a specific event
pub fn register(event: EventType, obj: anytype, func: anytype) !void {
    if (!initialized) {
        return error.NotInitialized;
    }
    
    std.log.info("registering event: {}", .{event});

    // check if we already have this one
    const optr = @ptrCast(opaqueT, obj);
    for (Callbacks[@enumToInt(event)].items) |c| {
        if (c.obj == optr) {
            return error.AlreadyRegistered;
        }
    }


    _ = try Callbacks[@enumToInt(event)].append(
        Callback{
            .obj = optr,
            .func = @ptrCast(opaquefn, func),
        },
    );
}

pub fn unregister(event: EventType, obj: anytype, func: anytype) !void {
    if (!initialized) {
        return error.NotInitialized;
    }
    // 
    const optr = @ptrCast(opaqueT, obj);
    const idx: i8 = blk: {
        var i: i8 = 0;
        for (Callbacks[@enumToInt(event)].items) |c| {
            if (c.obj == optr) {
                break :blk i;
            }
            i += 1;
        }
        break :blk -1;
    };

    if (idx == -1) {
        return error.CallbackNotFound;
    }

    // remove it if we find it
    _ = Callbacks[@enumToInt(event)].swapRemove(@intCast(usize,idx));
}

pub fn send(event: Event) !void {
    if (!initialized) {
        return error.NotInitialized;
    }

    // TODO: propegate messages and make async
    // for now, we can directly call the callbacks
    for (Callbacks[@enumToInt(event)].items) |c| {
        c.func(c.obj, event);
    }
}

