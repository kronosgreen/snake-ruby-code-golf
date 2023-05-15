require 'ruby2d'

SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480

set title: 'Snake',
    background: 'black',
    width: SCREEN_WIDTH,
    height: SCREEN_HEIGHT,
    resizable: false

# Block Size
WIDTH = 20
HEIGHT = 20

# Borders
Rectangle.new(  x: 0, y: 0, width: SCREEN_WIDTH, height: HEIGHT, color: 'white')
Rectangle.new(  x: 0, y: 0, width: WIDTH, height: SCREEN_HEIGHT, color: 'white')
Rectangle.new(  x: SCREEN_WIDTH - WIDTH, y: 0, width: WIDTH, height: SCREEN_HEIGHT, color: 'white')
Rectangle.new(  x: 0, y: SCREEN_HEIGHT - HEIGHT, width: SCREEN_WIDTH, height: HEIGHT, color: 'white')

# Snake Body
class Snake
    attr_accessor :body

    def initialize
        @body = []
        @body.push(Rectangle.new(
            x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2,
            width: WIDTH, height: HEIGHT
        ))
        @apple = Rectangle.new(
            x: (1 + Random.rand(SCREEN_WIDTH/WIDTH - 2)) * WIDTH, y: (1 + Random.rand(SCREEN_HEIGHT/HEIGHT - 2)) * HEIGHT,
            width: WIDTH, height: HEIGHT, color: 'white'
        )
    end

    def move(x_change, y_change)
        head_x = @body[0].x
        head_y = @body[0].y
        @body.insert(0, Rectangle.new(
            x: head_x + x_change, y: head_y + y_change,
            width: WIDTH, height: HEIGHT
        ))
        if !check_apple
            @body.last.remove
            @body.pop
        end
        if check_collision
            reset_snake
        end
    end

    def check_collision
        @body.each_with_index do |block, index|
            if index > 0
                if @body[0].x == block.x && @body[0].y == block.y
                    return true
                end
            end
        end
        return @body[0].x < WIDTH || @body[0].x > SCREEN_WIDTH - WIDTH || @body[0].y < HEIGHT || @body[0].y > SCREEN_HEIGHT - HEIGHT
    end

    def check_apple
        if @body[0].x == @apple.x && @body[0].y == @apple.y
            @apple.x = (1 + Random.rand(SCREEN_WIDTH/WIDTH - 2)) * WIDTH
            @apple.y = (1 + Random.rand(SCREEN_HEIGHT/HEIGHT - 2)) * HEIGHT
            return true
        end
        return false
    end

    def reset_snake
        @body.each do |block|
            block.remove
        end
        @body.clear
        @body.push(Rectangle.new(
            x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2,
            width: WIDTH, height: HEIGHT
        ))
    end

end

dirs = Hash.new
dirs['right'] = [WIDTH, 0]
dirs['left'] = [-WIDTH, 0]
dirs['up'] = [0, -HEIGHT]
dirs['down'] = [0, HEIGHT]

direction = 'right'

snake = Snake.new

on :key_down do |event|
    if event.key == 'up' && direction != 'down'
        direction = 'up'
    elsif event.key == 'down' && direction != 'up'
        direction = 'down'
    elsif event.key == 'left' && direction != 'right'
        direction = 'left'
    elsif event.key == 'right' && direction != 'left'
        direction = 'right'
    end
end

update do
    snake.move(*dirs[direction])
    sleep(0.2)
end

show