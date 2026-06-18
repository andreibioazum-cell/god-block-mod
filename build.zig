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

    // Находим NDK только для путей линковки
    const ndk_home = b.graph.env_map.get("ANDROID_NDK_HOME") orelse "";
    if (ndk_home.len > 0) {
        const lib_path = b.fmt("{s}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/aarch64-linux-android/30", .{ndk_home});
        lib.addLibraryPath(.{ .cwd_relative = lib_path });
    }

    // Линкуем только то, что реально нужно
    lib.linkSystemLibrary("GLESv2");
    lib.linkSystemLibrary("EGL");
    lib.linkSystemLibrary("android");
    lib.linkSystemLibrary("log");

    b.installArtifact(lib);
}
