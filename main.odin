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
	rl.SetExitKey(.Q)

	rl.SetTargetFPS(60)

	direction := gridPos{1, 0}
	moveInterval: f32 = 0.1
	moveTimer: f32

	snake := make([dynamic]gridPos, 0, 20)
	defer delete(snake)
	append(&snake, gridPos{3, 4})
	append(&snake, gridPos{2, 4})
	append(&snake, gridPos{1, 4})

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		for i in 0 ..< TOTAL_SIZE {
			for j in 0 ..< TOTAL_SIZE {
				drawGridPos(gridPos{i32(i), i32(j)})
			}
		}


		moveTimer += rl.GetFrameTime()
		if moveTimer >= moveInterval {
			moveSnake(&snake, direction)
			drawSnakePos(snake)
			moveTimer = 0
		} else {
			drawSnakePos(snake)
		}


		rl.EndDrawing()
	}

	rl.CloseWindow()
}

// gridPos represents the top-left position in a grid:
// P .
// . .
gridPos :: struct {
	x: i32,
	y: i32,
}

drawGridPos :: proc(sPos: gridPos) {
	scrPos := getScreenPosition(sPos)
	rl.DrawRectangleLines(scrPos.x, scrPos.y, SQUARE_SIZE, SQUARE_SIZE, rl.BLACK)
}

getScreenPosition :: proc(gPos: gridPos) -> gridPos {
	// FIX: avoid re-computing this everytime function it's called
	gridOffsetX := (WIN_WIDTH - GRID_SIZE) / 2
	gridOffsetY := (WIN_HEIGHT - GRID_SIZE) / 2

	startPosX := (gPos.x * SQUARE_SIZE) + i32(gridOffsetX)
	startPosY := (gPos.y * SQUARE_SIZE) + i32(gridOffsetY)

	return gridPos{startPosX, startPosY}
}

gridToScreen :: proc(gPos: gridPos) -> rl.Rectangle {
	// FIX: avoid re-computing this everytime function it's called
	gridOffsetX := (WIN_WIDTH - GRID_SIZE) / 2
	gridOffsetY := (WIN_HEIGHT - GRID_SIZE) / 2

	startPosX := (gPos.x * SQUARE_SIZE) + i32(gridOffsetX)
	startPosY := (gPos.y * SQUARE_SIZE) + i32(gridOffsetY)

	return rl.Rectangle{f32(startPosX), f32(startPosY), SQUARE_SIZE, SQUARE_SIZE}
}

drawSnakePos :: proc(gPositions: [dynamic]gridPos) {
	for gPos, _ in gPositions {
		rect := gridToScreen(gPos)
		rl.DrawRectangleRec(rect, rl.GREEN)
	}
}
moveSnake :: proc(snake: ^[dynamic]gridPos, direction: gridPos) {
	head := snake[0]
	newHead := gridPos {
		x = head.x + direction.x,
		y = head.y + direction.y,
	}

	for i := len(snake) - 1; i > 0; i -= 1 {
		snake[i] = snake[i - 1]
	}
	snake[0] = newHead
}
