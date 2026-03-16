package main

import rl "vendor:raylib"

// 12x12 grid; 50px
// 50 * 12 = 600

GRID_SIZE :: 600
SQUARE_SIZE :: 50
TOTAL_SIZE :: GRID_SIZE / SQUARE_SIZE

WIN_WIDTH :: 1280
WIN_HEIGHT :: 720

Direction :: enum {
	LEFT,
	UP,
	RIGHT,
	DOWN,
}

getDirectionPos :: proc(direction: Direction) -> gridPos {
	switch direction {
	case .LEFT:
		return {-1, 0}
	case .UP:
		return {0, -1}
	case .RIGHT:
		return {1, 0}
	case .DOWN:
		return {0, 1}
	}
	return {1, 0}
}

main :: proc() {
	rl.InitWindow(WIN_WIDTH, WIN_HEIGHT, "Odin Monkey")
	rl.SetExitKey(.Q)

	rl.SetTargetFPS(60)

	direction := Direction.LEFT
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

		// left
		if rl.IsKeyPressed(.H) && direction != .RIGHT {
			direction = .LEFT
		}
		// down
		if rl.IsKeyPressed(.J) && direction != .UP {
			direction = .DOWN
		}
		// up
		if rl.IsKeyPressed(.K) && direction != .DOWN {
			direction = .UP
		}
		// right
		if rl.IsKeyPressed(.L) && direction != .LEFT {
			direction = .RIGHT
		}

		moveTimer += rl.GetFrameTime()
		if moveTimer >= moveInterval {
			moveSnake(&snake, getDirectionPos(direction))
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
	for gPos, i in gPositions {
		rect := gridToScreen(gPos)
		if i == 0 {
			rl.DrawRectangleRec(rect, rl.RED)
			continue
		}
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
