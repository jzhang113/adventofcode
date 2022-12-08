# frozen_string_literal: true

require_relative './base_solution'
require_relative '../input'

class Solution < BaseSolution
  include Input

  EXCLUDED_INSTANCE_VARS << 'grid'

  def make_grid
    @grid ||= input.map { |row| row.split('').map(&:to_i) }
    @height ||= input.length
    @width ||= input[0].length
  end

  def is_visible(x, y, grid)
    return true if (0...x).all? { |nx| grid[y][x] > grid[y][nx] }
    return true if ((x + 1)...@width).all? { |nx| grid[y][x] > grid[y][nx] }
    return true if (0...y).all? { |ny| grid[y][x] > grid[ny][x] }
    return true if ((y + 1)...@height).all? { |ny| grid[y][x] > grid[ny][x]}

    false
  end

  def trees_in_dir(x, y, grid)
    a = (0...x).to_a.reverse.take_while { |nx| grid[y][x] > grid[y][nx] }.count
    a += 1 if a < x

    b = ((x + 1)...@width).take_while { |nx| grid[y][x] > grid[y][nx] }.count
    b += 1 if b < (@width - x - 1)

    c = (0...y).to_a.reverse.take_while { |ny| grid[y][x] > grid[ny][x] }.count
    c += 1 if c < y

    d = ((y + 1)...@height).take_while { |ny| grid[y][x] > grid[ny][x] }.count
    d += 1 if d < (@height - y - 1)

    [a, b, c, d]
  end

  def before_block
    make_grid
  end

  def part1
    count = (1...(@width - 1)).sum do |row|
      (1...(@height - 1)).sum do |col|
        is_visible(row, col, @grid) ? 0 : 1
      end
    end

    @width * @height - count
  end

  def part2
    (1...(@width - 1)).map do |row|
      (1...(@height - 1)).map do |col|
        trees_in_dir(row, col, @grid).reduce(:*)
      end.max
    end.max
  end
end

Solution.new.run
