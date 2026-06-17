#include "raylib.h"
#include <math.h>

int main(void)
{
    InitWindow(0, 0, "Cubic Battle");

    Camera3D camera = { 0 };
    camera.position = (Vector3){ 10.0f, 10.0f, 10.0f };
    camera.target   = (Vector3){ 0.0f, 0.0f, 0.0f };
    camera.up       = (Vector3){ 0.0f, 1.0f, 0.0f };
    camera.fovy     = 45.0f;
    camera.projection = CAMERA_PERSPECTIVE;

    SetTargetFPS(60);

    while (!WindowShouldClose())
    {
        float t = GetTime();
        camera.position.x = 12.0f * cosf(t);
        camera.position.z = 12.0f * sinf(t);

        BeginDrawing();
            ClearBackground(SKYBLUE);
            BeginMode3D(camera);
                DrawGrid(20, 1.0f);
                DrawCube((Vector3){0,1,0}, 2,2,2, RED);
                DrawCubeWires((Vector3){0,1,0}, 2,2,2, MAROON);
            EndMode3D();
            DrawFPS(20, 60);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
