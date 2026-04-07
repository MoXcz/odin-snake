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

Game :: struct {
	snake:   Snake,
	is_over: bool,
}

game_init :: proc() -> Game {
	game: Game
	start_pos := [2]i32{NUM_CELLS / 2, NUM_CELLS / 2}

	game.snake.head = start_pos
	game.snake.body[0] = start_pos - {1, 0}
	game.snake.body[1] = start_pos - {2, 0}
	game.snake.direction = .LEFT
	game.is_over = false

	return game
}

main :: proc() {
	rl.InitWindow(WIN_WIDTH, WIN_HEIGHT, "Odin Snake")
	rl.SetExitKey(.Q)

	rl.SetTargetFPS(60)

	move_interval: f32 = 0.1
	move_timer: f32

	game := game_init()

	for (!rl.WindowShouldClose()) {
		if rl.IsKeyPressed(.H) && game.snake.direction != .RIGHT {
			game.snake.direction = .LEFT
		}
		if rl.IsKeyPressed(.J) && game.snake.direction != .UP {
			game.snake.direction = .DOWN
		}
		if rl.IsKeyPressed(.K) && game.snake.direction != .DOWN {
			game.snake.direction = .UP
		}
		if rl.IsKeyPressed(.L) && game.snake.direction != .LEFT {
			game.snake.direction = .RIGHT
		}
		if game.is_over {
			if rl.IsKeyPressed(.ENTER) {
				game = game_init()
			}
		} else {
			move_timer += rl.GetFrameTime()
		}

		if move_timer >= move_interval {
			move_snake(&game.snake)

			head := game.snake.head
			if head.x < 0 || head.y < 0 || head.x >= NUM_CELLS || head.y >= NUM_CELLS {
				game.is_over = true
				game.snake.direction = .LEFT
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
		draw_snake_pos(game.snake)

		if game.is_over {
			rl.DrawText("Game Over", 2, 2, 32, rl.RED)
		}

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}

Snake :: struct {
	head:      [2]i32,
	body:      [10][2]i32,
	direction: Direction,
}

get_snake_rect :: proc(body_part: [2]i32) -> rl.Rectangle {
	return {
		x = f32(body_part.x * CELL_SIZE),
		y = f32(body_part.y * CELL_SIZE),
		width = CELL_SIZE,
		height = CELL_SIZE,
	}
}

draw_snake_pos :: proc(snake: Snake) {
	rl.DrawRectangleRec(get_snake_rect(snake.head), rl.RED)
	for snakePart, i in snake.body {
		rect := get_snake_rect(snakePart)
		rl.DrawRectangleRec(rect, rl.GREEN)
	}
}

move_snake :: proc(snake: ^Snake) {
	head := snake.head
	directionPos := get_direction_pos(snake.direction)
	newHead := [2]i32{head.x + directionPos.x, head.y + directionPos.y}

	for i := len(snake.body) - 1; i > 0; i -= 1 {
		snake.body[i] = snake.body[i - 1]
	}
	snake.head = newHead
}
