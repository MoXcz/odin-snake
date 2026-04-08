package main

import rl "vendor:raylib"

Snake :: struct {
	head:          [2]i32,
	snake_length:  i32,
	body:          [10][2]i32,
	direction:     Direction,
	move_interval: f32,
	timer:         f32,
}

get_snake_rect :: proc(body_part: [2]i32) -> rl.Rectangle {
	return {
		x = f32(body_part.x * CELL_SIZE),
		y = f32(body_part.y * CELL_SIZE),
		width = CELL_SIZE,
		height = CELL_SIZE,
	}
}

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


draw_snake :: proc(snake: Snake) {
	rl.DrawRectangleRec(get_snake_rect(snake.head), rl.RED)
	for i in 0 ..< snake.snake_length {
		rect := get_snake_rect(snake.body[i])
		rl.DrawRectangleRec(rect, rl.GREEN)
	}
}

snake_update :: proc(snake: ^Snake, dt: f32) {
	if rl.IsKeyPressed(.H) && snake.direction != .RIGHT {
		snake.direction = .LEFT
	}
	if rl.IsKeyPressed(.J) && snake.direction != .UP {
		snake.direction = .DOWN
	}
	if rl.IsKeyPressed(.K) && snake.direction != .DOWN {
		snake.direction = .UP
	}
	if rl.IsKeyPressed(.L) && snake.direction != .LEFT {
		snake.direction = .RIGHT
	}

	snake.timer += dt
	if snake.timer >= snake.move_interval {
		for i := snake.snake_length - 1; i > 0; i -= 1 {
			snake.body[i] = snake.body[i - 1]
		}
		snake.body[0] = snake.head
		snake.head += get_direction_pos(snake.direction)

		snake.timer = 0
	}
}
