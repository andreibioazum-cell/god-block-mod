const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "CubicBattle",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Линкуем системные библиотеки Android
    lib.linkSystemLibrary("GLESv2");
    lib.linkSystemLibrary("EGL");
    lib.linkSystemLibrary("android");
    lib.linkLibC();

    b.installArtifact(lib);
}
