package main

import rl "vendor:raylib"

// 12x12 grid; 50px
// 50 * 12 = 600

GRID_SIZE :: 600
CELL_SIZE :: 50
TOTAL_SIZE :: GRID_SIZE / CELL_SIZE

WIN_WIDTH :: 1280
WIN_HEIGHT :: 720

GRID_OFFSET_X :: (WIN_WIDTH - GRID_SIZE) / 2
GRID_OFFSET_Y :: (WIN_HEIGHT - GRID_SIZE) / 2

Direction :: enum {
	LEFT,
	UP,
	RIGHT,
	DOWN,
}

get_direction_pos :: proc(direction: Direction) -> Snake {
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

	snake := make([dynamic]Snake, 0, 20)
	defer delete(snake)
	append(&snake, Snake{3, 4})
	append(&snake, Snake{2, 4})
	append(&snake, Snake{1, 4})

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		for i in 0 ..< TOTAL_SIZE {
			for j in 0 ..< TOTAL_SIZE {
				draw_grid_pos(Snake{i32(i), i32(j)})
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
			move_snake(&snake, get_direction_pos(direction))
			draw_snake_pos(snake)
			moveTimer = 0
		} else {
			draw_snake_pos(snake)
		}


		rl.EndDrawing()
	}

	rl.CloseWindow()
}

// gridPos represents the top-left position in a grid:
// P .
// . .
Snake :: struct {
	x: i32,
	y: i32,
}

draw_grid_pos :: proc(sPos: Snake) {
	scrPos := get_screen_pos(sPos)
	rl.DrawRectangleLines(scrPos.x, scrPos.y, CELL_SIZE, CELL_SIZE, rl.BLACK)
}

get_screen_pos :: proc(gPos: Snake) -> Snake {
	return Snake {
		x = (gPos.x * CELL_SIZE) + GRID_OFFSET_X,
		y = (gPos.y * CELL_SIZE) + GRID_OFFSET_Y,
	}
}

grid_to_screen :: proc(gPos: Snake) -> rl.Rectangle {
	gPos := get_screen_pos(gPos)
	return rl.Rectangle{x = f32(gPos.x), y = f32(gPos.y), width = CELL_SIZE, height = CELL_SIZE}
}

draw_snake_pos :: proc(gPositions: [dynamic]Snake) {
	for gPos, i in gPositions {
		rect := grid_to_screen(gPos)
		if i == 0 {
			rl.DrawRectangleRec(rect, rl.RED)
			continue
		}
		rl.DrawRectangleRec(rect, rl.GREEN)
	}
}

move_snake :: proc(snake: ^[dynamic]Snake, direction: Snake) {
	head := snake[0]
	newHead := Snake {
		x = head.x + direction.x,
		y = head.y + direction.y,
	}

	for i := len(snake) - 1; i > 0; i -= 1 {
		snake[i] = snake[i - 1]
	}
	snake[0] = newHead
}
