# frozen_string_literal: true

require_relative './base_solution'
require_relative '../input'

class Solution < BaseSolution
  include Input

  # Define a start position of map "screen"
  SCREEN_OFFSET = 300

  def make_map
    map = Array.new(200) { Array.new(400, 0) }
    @floor = 0

    input.each do |line|
      points = line.split(' -> ').map { |pt| pt.split(',').map(&:to_i) }

      (points.length - 1).times do |idx|
        x0, y0 = points[idx]
        x1, y1 = points[idx + 1]

        # Swap indices so that x0 < x1 and y0 < y1
        x0, x1 = x1, x0 unless x0 < x1
        y0, y1 = y1, y0 unless y0 < y1

        # Track the lowest seen point (for part 2)
        @floor = y1 if y1 > @floor

        (y0..y1).each { |y| map[y][x0 - SCREEN_OFFSET] = 1 } if x0 == x1
        (x0..x1).each { |x| map[y0][x - SCREEN_OFFSET] = 1 } if y0 == y1
      end
    end

    map
  end

  def print_map(map, file = $stdout)
    map.each do |row|
      row.each do |cell|
        case cell
        in 0
          file.write ' '
        in 1
          file.write '█'
        in 2
          file.write 'o'
        end
      end
      file.write "\n"
    end
  end

  # Returns the next position a sand at [x, y] will move to
  # The first parameter indicates if the sand is done falling or not
  def next_sand_pos(x, y, map)
    [[0, 1], [-1, 1], [1, 1]].each do |dx, dy|
      return [false, x + dx, y + dy] if map[y + dy][x + dx] == 0
    end

    [true, x, y]
  end

  def before_block
    @start_x = 500 - SCREEN_OFFSET
    @start_y = 0
  end

  def part1
    map = make_map
    count = 0
    done = false

    until done
      sand_x = @start_x
      sand_y = @start_y
      sand_resting = false

      until sand_resting
        # If a sand will fall off the map, we are done
        if sand_y + 1 >= map.length
          done = true
          break
        end

        sand_resting, sand_x, sand_y = next_sand_pos(sand_x, sand_y, map)
      end

      count += 1
      map[sand_y][sand_x] = 2
    end

    # print_map(map)

    # -1 to the count since there's one extra grain that's falling off the map
    count - 1
  end

  def part2
    map = make_map
    count = 0

    # Continue until the source is blocked
    until map[@start_y][@start_x] == 2
      sand_x = @start_x
      sand_y = @start_y
      sand_resting = false

      # Same as part 1, but we can stop once the sand has reached the floor
      sand_resting, sand_x, sand_y = next_sand_pos(sand_x, sand_y, map) until sand_y >= @floor + 1 || sand_resting

      count += 1
      map[sand_y][sand_x] = 2
    end

    # File.open('output', 'w') { |f| print_map(map, f) }

    count
  end
end

Solution.new.run
