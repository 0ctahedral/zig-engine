const std = @import("std");
const testing = std.testing;
const event = @import("event.zig");
const Event = event.Event;
const EventType = event.EventType;

const dummy = struct {
    f1: f32,
    pub fn addone(self: *@This(), ev: Event) void {
        self.f1 += 1;
    }
};

var d1 = dummy{
    .f1 = 32,
};

test "not initialized" {
    try testing.expectError(error.NotInitialized, event.register(EventType.Quit, &d1, dummy.addone));
    try testing.expectError(error.NotInitialized, event.unregister(EventType.Quit, &d1, dummy.addone));
    try testing.expectError(error.NotInitialized, event.send(Event{.Quit={}}));
}

test "already registered" {
    event.init(std.heap.page_allocator);
    defer event.deinit();

    try event.register(EventType.Quit, &d1, dummy.addone);
    try testing.expectError(error.AlreadyRegistered, event.register(EventType.Quit, &d1, dummy.addone));
}

test "send type not registered for" {
    d1.f1 = 32;

    event.init(std.heap.page_allocator);
    defer event.deinit();

    try event.register(EventType.Quit, &d1, dummy.addone);

    try event.send(Event{.MouseMoved=.{.x=0, .y=10,}});
    try testing.expect(d1.f1 == 32);

    try event.send(Event{.Quit={}});
    try testing.expect(d1.f1 == 33);
}

test "two instances with different events" {
    d1.f1 = 32;

    var d2 = dummy{
        .f1 = 32,
    };

    event.init(std.heap.page_allocator);
    defer event.deinit();
    try event.register(EventType.Quit, &d1, dummy.addone);
    try event.register(EventType.MouseMoved, &d2, dummy.addone);

    try event.send(Event{.Quit={}});
    try testing.expect(d1.f1 == 33);
    try testing.expect(d2.f1 == 32);
}

test "multiple events" {
    d1.f1 = 32;

    event.init(std.heap.page_allocator);
    defer event.deinit();

    try event.register(EventType.Quit, &d1, dummy.addone);
    try event.register(EventType.MouseMoved, &d1, dummy.addone);

    try event.send(Event{.Quit={}});
    try event.send(Event{.MouseMoved=.{.x=10,.y=0}});
    try testing.expect(d1.f1 == 34);
}
