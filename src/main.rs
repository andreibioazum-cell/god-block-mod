use macroquad::prelude::*;

#[macroquad::main("Cubic Battle")]
async fn main() {
    loop {
        clear_background(SKYBLUE);

        set_camera(&Camera3D {
            position: vec3(10., 10., 10.),
            up: vec3(0., 1., 0.),
            target: vec3(0., 0., 0.),
            ..Default::default()
        });

        draw_grid(20, 1., GRAY, DARKGRAY);
        draw_cube(vec3(0., 1., 0.), vec3(2., 2., 2.), None, RED);

        set_default_camera();
        draw_text("Cubic Battle (Rust)", 20., 40., 30., BLACK);

        next_frame().await
    }
}
