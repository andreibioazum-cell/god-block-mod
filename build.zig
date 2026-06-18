const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Создаем общую библиотеку для Android
    const lib = b.addSharedLibrary(.{
        .name = "CubicBattle",
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Подключаем Sokol
    const dep_sokol = b.dependency("sokol", .{
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.addImport("sokol", dep_sokol.module("sokol"));

    // Это нужно, чтобы артефакт попал в zig-out/lib
    b.installArtifact(lib);
}
