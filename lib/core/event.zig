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

/// Helper types
/// otype is an opaque pointer
const otype = *opaque{};
/// ofunc is a function pinter 
const ofunc = fn(otype, Event)void;
/// An event callback that has been registered with this system
const entry = struct {
    fptr: otype,
    lptr: ofunc,
};
/// ArrayList of entries to a specific event
const event_entry = struct {
    entries: ?std.ArrayList(entry) = null,
};

/// stores all the event entries
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
        if (ee.entries != null) {
            ee.entries.?.deinit();
        }
    }
}

/// Register a callback for a specific event
pub fn register(event: EventType, comptime T: type, listener: *T, func: fn(*T, Event)void) !void {
    if (!initialized) {
        return error.NotInitialized;
    }
    
    std.log.info("registering event: {}", .{event});

    // get the event we want to register
    // if it is null, create the arraylist
    if (state.registered[@enumToInt(event)].entries == null) {
        state.registered[@enumToInt(event)].entries = std.ArrayList(entry).init(allocator);
    }
    // check if this function pointer is in the arraylist
    for (state.registered[@enumToInt(event)].entries.?.items) |l| {
        if (l.fptr == func) {
            return;
        }
    }
    // add to arraylist
    try state.registered[@enumToInt(event)].entries.?.append(entry(T, listener, func){});

}

pub fn unregister(event: EventType, func: fn(Event)void) !void {
    if (!initialized) {
        return error.NotInitialized;
    }
    // get the event we want to unregister
    // if it is null, return
    if (state.registered[@enumToInt(event)].entries == null) {
        return;
    }
    var items = state.registered[@enumToInt(event)].entries.?.items;
    // check if this function pointer is in the arraylist
    // remove from arraylist
    var i: usize = 0;
    while (i < items.len)
        : (i+=1) {
            if (items[i].func == func) {
                _ = state.registered[@enumToInt(event)].entries.?.swapRemove(i);
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
    if (state.registered[@enumToInt(event)].entries == null) {
        return;
    }
    // otherwise, find all entries and send the event
    for (state.registered[@enumToInt(event)].entries.?.items) |l| {
        l.fptr(l.lptr, event);
    }
}
