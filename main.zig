const std = @import("std");
const sokol = @import("sokol");
const sapp = sokol.app;
const sg = sokol.gfx;

pub fn main() void {
    sapp.run(.{
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
        .width = 1280,
        .height = 720,
        .window_title = "Zig Cubic Battle",
    });
}

fn init() void {
    sg.setup(.{ .context = sapp.defaultContext() });
}

fn frame() void {
    var pass_action = sg.PassAction{};
    pass_action.colors[0] = .{ .load_action = .CLEAR, .clear_value = .{ .r = 0.2, .g = 0.6, .b = 0.9, .a = 1.0 } };
    sg.beginPass(.{ .action = pass_action, .swapchain = sapp.swapchain() });
    // Тут будет твой воксельный движок
    sg.endPass();
    sg.commit();
}

fn cleanup() void {
    sg.shutdown();
}
