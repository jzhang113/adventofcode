# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  DIRS = [-1, 0, 1].product([-1, 0, 1])

  def part1
    parts = []
    grid = []
    input.each do |line|
      grid << line.split('')
    end

    grid.each_with_index do |line, row|
      line.each_with_index do |sym, col|
        next unless sym != '.' && !sym.is_i?

        DIRS.each do |dx, dy|
          adjacent_cell = grid[row + dy][col + dx]
          parts << get_value!(grid, row + dy, col + dx) if adjacent_cell.is_i?
        end
      end
    end

    parts.sum
  end

  def part2
    ratios = []
    grid = []
    input.each do |line|
      grid << line.split('')
    end

    grid.each_with_index do |line, row|
      line.each_with_index do |sym, col|
        next unless sym == '*'

        parts = []
        DIRS.each do |dx, dy|
          adjacent_cell = grid[row + dy][col + dx]
          parts << get_value!(grid, row + dy, col + dx) if adjacent_cell.is_i?
        end

        ratios << parts[0] * parts[1] if parts.count == 2
      end
    end

    ratios.sum
  end

  # Obtain the number at a given position on the grid; any digits to the immediate
  # left or right of the provided position is considered part of the same number.
  # This method is destructive, and will replace the cells on the grid with '.'
  def get_value!(grid, row, col)
    value = grid[row][col]
    grid[row][col] = '.'

    rx = col - 1
    while rx >= 0 && grid[row][rx].is_i?
      value = grid[row][rx] + value
      grid[row][rx] = '.'
      rx -= 1
    end

    rx = col + 1
    while rx < grid[0].length && grid[row][rx].is_i?
      value += grid[row][rx]
      grid[row][rx] = '.'
      rx += 1
    end

    value.to_i
  end
end

Solution.new.run
