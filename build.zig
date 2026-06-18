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

    // Получаем путь к NDK
    const ndk_home = b.graph.env_map.get("ANDROID_NDK_HOME") orelse "";
    if (ndk_home.len > 0) {
        const base = b.fmt("{s}/toolchains/llvm/prebuilt/linux-x86_64/sysroot", .{ndk_home});
        
        // Добавляем пути к заголовочным файлам (Headers)
        lib.addIncludePath(.{ .cwd_relative = b.fmt("{s}/usr/include", .{base}) });
        lib.addIncludePath(.{ .cwd_relative = b.fmt("{s}/usr/include/aarch64-linux-android", .{base}) });
        
        // Добавляем пути к библиотекам (Libraries)
        lib.addLibraryPath(.{ .cwd_relative = b.fmt("{s}/usr/lib/aarch64-linux-android/30", .{base}) });
    }

    // Линкуем системные библиотеки Android
    lib.linkSystemLibrary("GLESv2");
    lib.linkSystemLibrary("EGL");
    lib.linkSystemLibrary("android");
    lib.linkSystemLibrary("log");
    
    // ВАЖНО: Вместо lib.linkLibC() линкуем 'c' как системную библиотеку NDK.
    // Это обходит ошибку "libc not available".
    lib.linkSystemLibrary("c");
    lib.linkSystemLibrary("m");

    b.installArtifact(lib);
}
