package main

import rl "vendor:raylib"

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
	game.snake.snake_length = 2
	game.snake.direction = .LEFT
	game.is_over = false
	game.snake.move_interval = 0.1

	return game
}

game_draw :: proc(game: ^Game) {
	rl.ClearBackground(rl.WHITE)

	if game.is_over {
		rl.DrawText("Game Over", 2, 2, 32, rl.RED)
		rl.DrawText("Press Enter to play again", 4, 30, 15, rl.BLACK)
		return
	}

	rl.DrawRectangleLines(0, 0, GRID_SIZE, GRID_SIZE, rl.BLACK)

	draw_snake(game.snake)
}

game_update :: proc(game: ^Game, dt: f32) {
	if game.is_over {
		if rl.IsKeyPressed(.ENTER) {
			game^ = game_init()
		}
		return
	}

	snake_update(&game.snake, dt)

	head := game.snake.head
	if head.x < 0 || head.y < 0 || head.x >= NUM_CELLS || head.y >= NUM_CELLS {
		game.is_over = true
		game.snake.direction = .LEFT
	}
}
