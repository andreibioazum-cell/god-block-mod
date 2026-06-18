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
    // Цвет травы в майнкрафте: R: 124, G: 157, B: 52
    pass_action.colors[0] = .{ 
        .load_action = .CLEAR, 
        .clear_value = .{ .r = 0.48, .g = 0.61, .b = 0.2, .a = 1.0 } 
    };
    
    sg.beginPass(.{ .action = pass_action, .swapchain = sapp.swapchain() });
    sg.endPass();
    sg.commit();
}

fn cleanup() void {
    sg.shutdown();
}
