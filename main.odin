package main

import rl "vendor:raylib"

// 12x12 grid; 50px
// 50 * 12 = 600

GRID_SIZE :: 600
SQUARE_SIZE :: 50
TOTAL_SIZE :: GRID_SIZE / SQUARE_SIZE

main :: proc() {
	rl.InitWindow(1280, 720, "Odin Monkey")
	rl.SetExitKey(rl.KeyboardKey.Q)

	rl.SetTargetFPS(60)

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		for i in 0 ..< TOTAL_SIZE {
			for j in 0 ..< TOTAL_SIZE {
				drawGridPos(gridPos{i32(i), i32(j)})
			}
		}

		rl.EndDrawing()
	}

	rl.CloseWindow()
}

screenPos :: struct {
	startPosX: i32,
	startPosY: i32,
	endPosX:   i32,
	endPosY:   i32,
}

gridPos :: struct {
	x: i32,
	y: i32,
}

drawGridPos :: proc(gPos: gridPos) {
	scrPos := getScreenPosition(gPos)
	rl.DrawRectangleLines(scrPos.startPosX, scrPos.startPosY, SQUARE_SIZE, SQUARE_SIZE, rl.BLACK)
}

getScreenPosition :: proc(gPos: gridPos) -> screenPos {
	startPosX := gPos.x * SQUARE_SIZE
	endPosX := startPosX + SQUARE_SIZE
	startPosY := gPos.y * SQUARE_SIZE
	endPosY := startPosY + SQUARE_SIZE

	return screenPos{startPosX, startPosY, endPosX, endPosY}
}
