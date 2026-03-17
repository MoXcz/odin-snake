package main

import rl "vendor:raylib"

NUM_CELLS :: 20
CELL_SIZE :: 25
GRID_SIZE :: NUM_CELLS * CELL_SIZE

WIN_WIDTH :: 1000
WIN_HEIGHT :: 1000

Direction :: enum {
	LEFT,
	UP,
	RIGHT,
	DOWN,
}

game_over: bool

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

start :: proc(snake: ^[dynamic]Snake) {
	clear(snake)
	start_pos := [2]i32{NUM_CELLS / 2, NUM_CELLS / 2}

	append(snake, Snake{start_pos})
	append(snake, Snake{start_pos - {1, 0}})
	append(snake, Snake{start_pos - {2, 0}})
	game_over = false
}

main :: proc() {
	rl.InitWindow(WIN_WIDTH, WIN_HEIGHT, "Odin Snake")
	rl.SetExitKey(.Q)

	rl.SetTargetFPS(60)

	direction := Direction.LEFT
	move_interval: f32 = 0.1
	move_timer: f32

	snake := make([dynamic]Snake, 0, 20)
	defer delete(snake)
	start(&snake)

	for (!rl.WindowShouldClose()) {
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
		if game_over {
			if rl.IsKeyPressed(.ENTER) {
				start(&snake)
			}
		} else {
			move_timer += rl.GetFrameTime()
		}

		if move_timer >= move_interval {
			move_snake(&snake, get_direction_pos(direction))

			head := snake[0]
			if head.pos.x < 0 ||
			   head.pos.y < 0 ||
			   head.pos.x >= NUM_CELLS ||
			   head.pos.y >= NUM_CELLS {
				game_over = true
				direction = .LEFT
			}
			move_timer = 0
		}

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		camera := rl.Camera2D {
			zoom = f32(WIN_HEIGHT) / GRID_SIZE,
		}
		rl.BeginMode2D(camera)

		rl.DrawRectangleLines(0, 0, GRID_SIZE, GRID_SIZE, rl.BLACK)
		draw_snake_pos(snake)

		if game_over {
			rl.DrawText("Game Over", GRID_SIZE / 2, GRID_SIZE / 2, 32, rl.RED)
		}

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}

Snake :: struct {
	// pos represents the top-left position in a grid
	pos: [2]i32,
}

get_snake_rect :: proc(snake: Snake) -> rl.Rectangle {
	return {
		x = f32(snake.pos.x * CELL_SIZE),
		y = f32(snake.pos.y * CELL_SIZE),
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
