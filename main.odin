package main

import rl "vendor:raylib"

// 12x12 grid; 50px
// 50 * 12 = 600

main :: proc() {
	rl.InitWindow(1280, 720, "Odin Monkey")
	rl.SetExitKey(rl.KeyboardKey.Q)

	rl.SetTargetFPS(60)

	gridSize := 600
	squareSize := 50
	totalSize := gridSize / squareSize

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		for i in 0 ..= totalSize {
			for j in 0 ..= totalSize {
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

	rl.DrawLine(scrPos.startPosX, scrPos.startPosY, scrPos.endPosX, scrPos.startPosY, rl.BLACK)
	rl.DrawLine(scrPos.startPosX, scrPos.startPosY, scrPos.startPosX, scrPos.endPosY, rl.BLACK)
	rl.DrawLine(scrPos.startPosX, scrPos.endPosY, scrPos.endPosX, scrPos.endPosY, rl.BLACK)
	rl.DrawLine(scrPos.endPosX, scrPos.startPosY, scrPos.endPosX, scrPos.endPosY, rl.BLACK)
}

getScreenPosition :: proc(gPos: gridPos) -> screenPos {
	startPosX := gPos.x * 50
	endPosX := startPosX + 50
	startPosY := gPos.y * 50
	endPosY := startPosY + 50

	return screenPos{startPosX, startPosY, endPosX, endPosY}
}
