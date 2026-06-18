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

    // Находим путь к NDK
    const ndk_home = b.graph.env_map.get("ANDROID_NDK_HOME") orelse "";
    if (ndk_home.len > 0) {
        // Указываем sysroot — это корень всех системных файлов для Android в NDK
        const sysroot = b.fmt("{s}/toolchains/llvm/prebuilt/linux-x86_64/sysroot", .{ndk_home});
        lib.sysroot = sysroot;

        // Добавляем путь к библиотекам именно для архитектуры aarch64 и API 30
        const lib_path = b.fmt("{s}/usr/lib/aarch64-linux-android/30", .{sysroot});
        lib.addLibraryPath(.{ .cwd_relative = lib_path });
    }

    // Линкуем графические библиотеки
    lib.linkSystemLibrary("GLESv2");
    lib.linkSystemLibrary("EGL");
    lib.linkSystemLibrary("android");
    
    // Подключаем LibC (теперь он найдет её в sysroot)
    lib.linkLibC();

    b.installArtifact(lib);
}
