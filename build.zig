const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const build_mode = b.standardReleaseOptions();

    // sandbox
    const sandbox = b.addExecutable("sandbox", "sandbox/main.zig");
    sandbox.setBuildMode(build_mode);
    linkEngineLib(b, sandbox, "");
    const sandbox_run_step = b.step("sandbox", "run the sandbox");
    sandbox_run_step.dependOn(&sandbox.run().step);

    // we will also make run shortcut to running the sandbox
    const run_step = b.step("run", "runs the sandbox");
    run_step.dependOn(&sandbox.run().step);

    // TODO: add test steps
    // TODO: move different iterations of the sandbox into an examples folder
}

// build as library and add to executable
pub fn linkEngineLib(
    b: *std.build.Builder,
    artifact: *std.build.LibExeObjStep,
    comptime prefix_path: []const u8,
) void {
    const build_mode = b.standardReleaseOptions();

    // create the library
    const lib = b.addSharedLibrary("engine", "lib/engine.zig", .unversioned);
    lib.setBuildMode(build_mode);
    lib.linkSystemLibrary("c");
    lib.linkSystemLibrary("xcb");
    lib.linkSystemLibrary("X11-xcb");
    lib.install();
    artifact.linkLibrary(lib);
    artifact.addPackage(.{
        .name = "engine",
        .path = prefix_path ++ "lib/engine.zig",
    });
}
