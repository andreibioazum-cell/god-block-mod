const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "CubicBattle",
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const sokol = b.dependency("sokol", .{
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.addImport("sokol", sokol.module("sokol"));

    b.installArtifact(lib);
}
