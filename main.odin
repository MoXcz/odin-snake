package main

import rl "vendor:raylib"

// 12x12 grid; 50px
// 50 * 12 = 600

GRID_SIZE :: 600
SQUARE_SIZE :: 50
TOTAL_SIZE :: GRID_SIZE / SQUARE_SIZE

WIN_WIDTH :: 1280
WIN_HEIGHT :: 720

main :: proc() {
	rl.InitWindow(WIN_WIDTH, WIN_HEIGHT, "Odin Monkey")
	rl.SetExitKey(rl.KeyboardKey.Q)

	rl.SetTargetFPS(60)

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		for i in 0 ..< TOTAL_SIZE {
			for j in 0 ..< TOTAL_SIZE {
				drawGridPos(screenPos{i32(i), i32(j)})
			}
		}

		rl.EndDrawing()
	}

	rl.CloseWindow()
}

screenPos :: struct {
	x: i32,
	y: i32,
}

drawGridPos :: proc(sPos: screenPos) {
	scrPos := getScreenPosition(sPos)
	rl.DrawRectangleLines(scrPos.x, scrPos.y, SQUARE_SIZE, SQUARE_SIZE, rl.BLACK)
}

getScreenPosition :: proc(gPos: screenPos) -> screenPos {
	gridOffsetX := (WIN_WIDTH - GRID_SIZE) / 2
	gridOffsetY := (WIN_HEIGHT - GRID_SIZE) / 2

	startPosX := (gPos.x * SQUARE_SIZE) + i32(gridOffsetX)
	startPosY := (gPos.y * SQUARE_SIZE) + i32(gridOffsetY)

	return screenPos{startPosX, startPosY}
}
