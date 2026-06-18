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

    // Получаем путь к NDK из переменной окружения
    const ndk_path = b.graph.env_map.get("ANDROID_NDK_HOME") orelse "";
    if (ndk_path.len > 0) {
        // Путь к системным библиотекам Android внутри NDK
        const sysroot_include = b.fmt("{s}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include", .{ndk_path});
        const sysroot_lib = b.fmt("{s}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/aarch64-linux-android/30", .{ndk_path});
        
        lib.addIncludePath(.{ .cwd_relative = sysroot_include });
        lib.addLibraryPath(.{ .cwd_relative = sysroot_lib });
        
        // Добавляем специфичные для Android инклуды
        const android_include = b.fmt("{s}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/aarch64-linux-android", .{ndk_path});
        lib.addIncludePath(.{ .cwd_relative = android_include });
    }

    lib.linkSystemLibrary("GLESv2");
    lib.linkSystemLibrary("EGL");
    lib.linkSystemLibrary("android");
    lib.linkLibC();

    b.installArtifact(lib);
}
