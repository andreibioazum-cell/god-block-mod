const std = @import("std");

// Типы для EGL и OpenGL (просто числа и указатели)
const EGLDisplay = ?*anyopaque;
const EGLConfig = ?*anyopaque;
const EGLContext = ?*anyopaque;
const EGLSurface = ?*anyopaque;
const EGLNativeWindowType = ?*anyopaque;
const EGLint = i32;

// Константы
const EGL_DEFAULT_DISPLAY: EGLDisplay = null;
const EGL_NO_CONTEXT: EGLContext = null;
const EGL_RENDERABLE_TYPE: EGLint = 0x3040;
const EGL_OPENGL_ES2_BIT: EGLint = 0x0004;
const EGL_NONE: EGLint = 0x3038;
const EGL_CONTEXT_CLIENT_VERSION: EGLint = 0x3098;

// Объявляем функции как extern (они лежат в .so библиотеках Android)
extern fn eglGetDisplay(display_id: EGLDisplay) EGLDisplay;
extern fn eglInitialize(dpy: EGLDisplay, major: ?*EGLint, minor: ?*EGLint) i32;
extern fn eglChooseConfig(dpy: EGLDisplay, attrib_list: [*]const EGLint, configs: ?[*]EGLConfig, config_size: EGLint, num_config: *EGLint) i32;
extern fn eglCreateWindowSurface(dpy: EGLDisplay, config: EGLConfig, win: EGLNativeWindowType, attrib_list: ?[*]const EGLint) EGLSurface;
extern fn eglCreateContext(dpy: EGLDisplay, config: EGLConfig, share_context: EGLContext, attrib_list: ?[*]const EGLint) EGLContext;
extern fn eglMakeCurrent(dpy: EGLDisplay, draw: EGLSurface, read: EGLSurface, ctx: EGLContext) i32;
extern fn eglSwapBuffers(dpy: EGLDisplay, surface: EGLSurface) i32;

extern fn glClearColor(r: f32, g: f32, b: f32, a: f32) void;
extern fn glClear(mask: u32) void;

// Структуры Android Native Activity
pub const ANativeActivity = extern struct {
    callbacks: *ANativeActivityCallbacks,
    vm: ?*anyopaque,
    env: ?*anyopaque,
    clazz: ?*anyopaque,
    internalDataPath: [*:0]const u8,
    externalDataPath: [*:0]const u8,
    sdkVersion: i32,
    instance: ?*anyopaque,
    assetManager: ?*anyopaque,
    obbPath: [*:0]const u8,
};

pub const ANativeActivityCallbacks = extern struct {
    onStart: ?*anyopaque = null,
    onResume: ?*anyopaque = null,
    onSaveInstanceState: ?*anyopaque = null,
    onPause: ?*anyopaque = null,
    onStop: ?*anyopaque = null,
    onDestroy: ?*anyopaque = null,
    onWindowFocusChanged: ?*anyopaque = null,
    onNativeWindowCreated: ?*fn (activity: *ANativeActivity, window: ?*anyopaque) callconv(.C) void = null,
    onNativeWindowResized: ?*anyopaque = null,
    onNativeWindowRedrawNeeded: ?*anyopaque = null,
    onNativeWindowDestroyed: ?*anyopaque = null,
    onInputQueueCreated: ?*anyopaque = null,
    onInputQueueDestroyed: ?*anyopaque = null,
    onContentRectChanged: ?*anyopaque = null,
    onConfigurationChanged: ?*anyopaque = null,
    onLowMemory: ?*anyopaque = null,
};

// Точка входа
pub export fn ANativeActivity_onCreate(activity: *ANativeActivity, _: ?*anyopaque, _: usize) void {
    activity.callbacks.onNativeWindowCreated = onWindowCreated;
}

fn onWindowCreated(_: *ANativeActivity, window: ?*anyopaque) callconv(.C) void {
    const display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    _ = eglInitialize(display, null, null);

    const config_attribs = [_]EGLint{ EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT, EGL_NONE };
    var config: EGLConfig = undefined;
    var num_config: EGLint = undefined;
    _ = eglChooseConfig(display, &config_attribs, &config, 1, &num_config);

    const surface = eglCreateWindowSurface(display, config, window, null);
    const context_attribs = [_]EGLint{ EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE };
    const context = eglCreateContext(display, config, EGL_NO_CONTEXT, &context_attribs);
    
    _ = eglMakeCurrent(display, surface, surface, context);

    var angle: f32 = 0;
    while (true) {
        angle += 0.01;
        const r = @abs(@sin(angle));
        glClearColor(r, 0.4, 0.7, 1.0);
        glClear(0x00004000 | 0x00000100); // COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT
        _ = eglSwapBuffers(display, surface);
    }
}
