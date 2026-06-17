use macroquad::prelude::*;

fn window_conf() -> Conf {
    Conf {
        window_title: "Cubic Battle".to_owned(),
        high_dpi: true,
        ..Default::default()
    }
}

#[macroquad::main(window_conf)]
async fn main() {
    loop {
        clear_background(SKYBLUE);

        // 3D Камера
        set_camera(&Camera3D {
            position: vec3(10.0, 10.0, 10.0),
            up: vec3(0.0, 1.0, 0.0),
            target: vec3(0.0, 0.0, 0.0),
            ..Default::default()
        });

        draw_grid(20, 1.0, GRAY, DARKGRAY);
        draw_cube(vec3(0.0, 1.0, 0.0), vec3(2.0, 2.0, 2.0), None, RED);
        draw_cube_wires(vec3(0.0, 1.0, 0.0), vec3(2.0, 2.0, 2.0), None, MAROON);

        set_default_camera();
        draw_text("Cubic Battle RUNNING!", 20.0, 60.0, 40.0, BLACK);
        draw_text(&format!("FPS: {}", get_fps()), 20.0, 100.0, 30.0, DARKGRAY);

        next_frame().await
    }
}
