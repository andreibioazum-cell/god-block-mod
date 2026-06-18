const std = @import("std");

// Импортируем системные библиотеки Android
const c = @cImport({
    @cInclude("EGL/egl.h");
    @cInclude("GLES2/gl2.h");
    @cInclude("android/native_activity.h");
    @cInclude("android/log.h");
});

const LOG_TAG = "ZigCubic";

// Точка входа для Android NativeActivity
pub export fn ANativeActivity_onCreate(activity: *c.ANativeActivity, saved_state: ?*anyopaque, saved_state_size: usize) void {
    _ = saved_state; _ = saved_state_size;
    activity.callbacks.*.onNativeWindowCreated = onWindowCreated;
}

fn onWindowCreated(activity: ?*c.ANativeActivity, window: ?*c.ANativeWindow) callconv(.C) void {
    const display = c.eglGetDisplay(c.EGL_DEFAULT_DISPLAY);
    _ = c.eglInitialize(display, null, null);

    const config_attribs = [_]c.EGLint{ 
        c.EGL_RENDERABLE_TYPE, c.EGL_OPENGL_ES2_BIT, 
        c.EGL_BLUE_SIZE, 8, c.EGL_GREEN_SIZE, 8, c.EGL_RED_SIZE, 8, 
        c.EGL_NONE 
    };
    
    var config: c.EGLConfig = undefined;
    var num_config: c.EGLint = undefined;
    _ = c.eglChooseConfig(display, &config_attribs, &config, 1, &num_config);

    const surface = c.eglCreateWindowSurface(display, config, window, null);
    const context_attribs = [_]c.EGLint{ c.EGL_CONTEXT_CLIENT_VERSION, 2, c.EGL_NONE };
    const context = c.eglCreateContext(display, config, c.EGL_NO_CONTEXT, &context_attribs);
    
    _ = c.eglMakeCurrent(display, surface, surface, context);

    // Игровой цикл
    var angle: f32 = 0;
    while (true) {
        angle += 0.01;
        // Цвет неба (динамически меняется)
        const r = @abs(@sin(angle));
        c.glClearColor(r, 0.6, 0.9, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT | c.GL_DEPTH_BUFFER_BIT);
        
        // Тут будет рендер твоих вокселей через glDrawArrays
        
        _ = c.eglSwapBuffers(display, surface);
    }
}
