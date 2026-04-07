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

Game :: struct {
	snake:     Snake,
	game_over: bool,
}

game_init :: proc() -> Game {
	game: Game
	start_pos := [2]i32{NUM_CELLS / 2, NUM_CELLS / 2}

	game.snake.head = start_pos
	game.snake.body[0] = start_pos - {1, 0}
	game.snake.body[1] = start_pos - {2, 0}
	game.game_over = false

	return game
}

main :: proc() {
	rl.InitWindow(WIN_WIDTH, WIN_HEIGHT, "Odin Snake")
	rl.SetExitKey(.Q)

	rl.SetTargetFPS(60)

	direction := Direction.LEFT
	move_interval: f32 = 0.1
	move_timer: f32

	game := game_init()

	for (!rl.WindowShouldClose()) {
		if rl.IsKeyPressed(.H) && direction != .RIGHT {
			direction = .LEFT
		}
		if rl.IsKeyPressed(.J) && direction != .UP {
			direction = .DOWN
		}
		if rl.IsKeyPressed(.K) && direction != .DOWN {
			direction = .UP
		}
		if rl.IsKeyPressed(.L) && direction != .LEFT {
			direction = .RIGHT
		}
		if game_over {
			if rl.IsKeyPressed(.ENTER) {
				game = game_init()
			}
		} else {
			move_timer += rl.GetFrameTime()
		}

		if move_timer >= move_interval {
			move_snake(&game.snake, get_direction_pos(direction))

			head := game.snake.head
			if head.x < 0 || head.y < 0 || head.x >= NUM_CELLS || head.y >= NUM_CELLS {
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
		draw_snake_pos(game.snake)

		if game_over {
			rl.DrawText("Game Over", 2, 2, 32, rl.RED)
		}

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}

Snake :: struct {
	head: [2]i32,
	body: [10][2]i32,
}

get_snake_rect :: proc(body_part: [2]i32) -> rl.Rectangle {
	return {
		x = f32(body_part.x * CELL_SIZE),
		y = f32(body_part.y * CELL_SIZE),
		width = CELL_SIZE,
		height = CELL_SIZE,
	}
}

draw_snake_pos :: proc(snakeParts: Snake) {
	for snakePart, i in snakeParts.body {
		rect := get_snake_rect(snakePart)
		if i == 0 {
			rl.DrawRectangleRec(rect, rl.RED)
			continue
		}
		rl.DrawRectangleRec(rect, rl.GREEN)
	}
}

move_snake :: proc(snake: ^Snake, direction: [2]i32) {
	head := snake.head
	newHead := [2]i32{head.x + direction.x, head.y + direction.y}

	for i := len(snake.body) - 1; i > 0; i -= 1 {
		snake.body[i] = snake.body[i - 1]
	}
	snake.head = newHead
}
