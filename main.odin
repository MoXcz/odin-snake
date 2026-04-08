package main

import rl "vendor:raylib"

NUM_CELLS :: 20
CELL_SIZE :: 25
GRID_SIZE :: NUM_CELLS * CELL_SIZE

WIN_WIDTH :: 1000
WIN_HEIGHT :: 1000

main :: proc() {
	rl.InitWindow(WIN_WIDTH, WIN_HEIGHT, "Odin Snake")
	rl.SetExitKey(.Q)
	rl.SetTargetFPS(60)

	game := game_init()

	for (!rl.WindowShouldClose()) {
		dt := rl.GetFrameTime()
		game_update(&game, dt)

		rl.BeginDrawing()

		camera := rl.Camera2D {
			zoom = f32(WIN_HEIGHT) / GRID_SIZE,
		}
		rl.BeginMode2D(camera)

		game_draw(&game)

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
