const std = @import("std");
const sokol = @import("sokol");
const gfx = sokol.gfx;

pub fn main() void {
    sokol.app.run(.{
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
        .width = 1280,
        .height = 720,
        .window_title = "Zig Cubic Battle",
    });
}

fn init() void {
    gfx.setup(.{ .context = sokol.app.defaultContext() });
}

fn frame() void {
    var pass_action = gfx.PassAction{};
    pass_action.colors[0] = .{ .load_action = .CLEAR, .clear_value = .{ .r = 0.1, .g = 0.6, .b = 0.8, .a = 1.0 } };
    
    gfx.beginPass(.{ .action = pass_action, .swapchain = sokol.app.swapchain() });
    // Тут будет отрисовка вокселей
    gfx.endPass();
    gfx.commit();
}

fn cleanup() void {
    gfx.shutdown();
}
