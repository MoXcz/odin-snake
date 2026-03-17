package main

import rl "vendor:raylib"

// 12x12 grid; 50px
// 50 * 12 = 600

NUM_CELLS :: 12
CELL_SIZE :: 50
GRID_SIZE :: NUM_CELLS * CELL_SIZE
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

get_direction_pos :: proc(direction: Direction) -> [2]i32 {
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
	rl.InitWindow(WIN_WIDTH, WIN_HEIGHT, "Odin Snake")
	rl.SetExitKey(.Q)

	rl.SetTargetFPS(60)

	direction := Direction.LEFT
	moveInterval: f32 = 0.1
	moveTimer: f32

	snake := make([dynamic]Snake, 0, 20)
	defer delete(snake)
	append(&snake, Snake{pos = {3, 4}})
	append(&snake, Snake{pos = {2, 4}})
	append(&snake, Snake{pos = {1, 4}})

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		rect := rl.Rectangle {
			x      = f32(GRID_OFFSET_X),
			y      = f32(GRID_OFFSET_Y),
			width  = GRID_SIZE,
			height = GRID_SIZE,
		}
		rl.DrawRectangleLines(GRID_OFFSET_X, GRID_OFFSET_Y, GRID_SIZE, GRID_SIZE, rl.BLACK)

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

Snake :: struct {
	// pos represents the top-left position in a grid
	pos: [2]i32,
}

get_snake_rect :: proc(snake: Snake) -> rl.Rectangle {
	return rl.Rectangle {
		x = f32((snake.pos.x * CELL_SIZE) + GRID_OFFSET_X),
		y = f32((snake.pos.y * CELL_SIZE) + GRID_OFFSET_Y),
		width = CELL_SIZE,
		height = CELL_SIZE,
	}
}

draw_snake_pos :: proc(snakeParts: [dynamic]Snake) {
	for snakePart, i in snakeParts {
		rect := get_snake_rect(snakePart)
		if i == 0 {
			rl.DrawRectangleRec(rect, rl.RED)
			continue
		}
		rl.DrawRectangleRec(rect, rl.GREEN)
	}
}

move_snake :: proc(snake: ^[dynamic]Snake, direction: [2]i32) {
	head := snake[0]
	newHead := Snake {
		pos = {head.pos.x + direction.x, head.pos.y + direction.y},
	}

	for i := len(snake) - 1; i > 0; i -= 1 {
		snake[i] = snake[i - 1]
	}
	snake[0] = newHead
}
