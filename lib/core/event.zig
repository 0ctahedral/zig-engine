//! Event subsystem

const std = @import("std");
const input = @import("input.zig");


const Allocator = std.mem.Allocator;

var allocator: *Allocator = undefined;
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

/// An event callback that has been registered with this system
const listener = struct {
    // TODO: keep track of listener object?
    func: fn(Event)void,
};

/// ArrayList of listeners to a specific event
const event_entry = struct {
    listeners: ?std.ArrayList(listener) = null,
};

/// stores all the event listeners
const eventState = struct {
    // array of registered events
    registered: [@typeInfo(EventType).Enum.fields.len]event_entry,
};

var state: eventState = undefined;

/// initialize the event subsystem
pub fn init(alloc: *Allocator) !void {
    allocator = alloc;
    initialized = true;

    // setup the state
    state = .{
        .registered =  [_]event_entry{
            .{}
        } ** @typeInfo(EventType).Enum.fields.len,
    };
}

/// shutdown the event subsystem
pub fn deinit() void {
    initialized = false;
    // destroy arraylists
    for (state.registered) |ee| {
        if (ee.listeners != null) {
            ee.listeners.?.deinit();
        }
    }
}

/// Register a callback for a specific event
pub fn register(event: EventType, func: fn(Event)void) !void {
    if (!initialized) {
        return error.NotInitialized;
    }
    
    std.log.info("registering event: {}", .{event});

    // get the event we want to register
    // if it is null, create the arraylist
    if (state.registered[@enumToInt(event)].listeners == null) {
        state.registered[@enumToInt(event)].listeners = std.ArrayList(listener).init(allocator);
    }
    // check if this function pointer is in the arraylist
    for (state.registered[@enumToInt(event)].listeners.?.items) |l| {
        if (l.func == func) {
            return;
        }
    }
    // add to arraylist
    try state.registered[@enumToInt(event)].listeners.?.append(
        .{.func = func});
}

pub fn unregister(event: EventType, func: fn(Event)void) !void {
    if (!initialized) {
        return error.NotInitialized;
    }
    // get the event we want to unregister
    // if it is null, return
    if (state.registered[@enumToInt(event)].listeners == null) {
        return;
    }
    var items = state.registered[@enumToInt(event)].listeners.?.items;
    // check if this function pointer is in the arraylist
    // remove from arraylist
    var i: usize = 0;
    while (i < items.len)
        : (i+=1) {
            if (items[i].func == func) {
                _ = state.registered[@enumToInt(event)].listeners.?.swapRemove(i);
            }
        }
}

pub fn send(event: Event) !void {
    if (!initialized) {
        return error.NotInitialized;
    }

    // TODO: propegate messages and make async
    // for now, we can directly call the callbacks

    // get the event we want to send
    // if it is null, return error
    if (state.registered[@enumToInt(event)].listeners == null) {
        return;
    }
    // otherwise, find all listeners and send the event
    for (state.registered[@enumToInt(event)].listeners.?.items) |l| {
        l.func(event);
    }
}
