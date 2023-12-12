# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def before_block
    @grid = input.map(&:chars)
    @expanding_rows = find_empty_rows(@grid)
    @expanding_cols = find_empty_rows(@grid.transpose)
  end

  def find_empty_rows(grid)
    grid.each_with_index
      .filter { |line, _| line.all? { |c| c == '.' } }
      .map(&:second)
  end

  def part1
    solve(2)
  end

  def part2
    solve(1_000_000)
  end

  def solve(expand_factor)
    find_stars.combination(2)
      .map { |p, q| find_dist(p, q, expand_factor) }
      .sum
  end

  def find_stars
    star_pos = []

    @grid.each_with_index do |line, row|
      line.each_with_index do |char, col|
        star_pos << [row, col] if char == '#'
      end
    end

    star_pos
  end

  def find_dist(p, q, expand_factor)
    crossed_rows = @expanding_rows.count { |r| yrange(p, q).cover? r }
    crossed_cols = @expanding_cols.count { |c| xrange(p, q).cover? c }

    manhatten_dist(p, q) + (crossed_rows + crossed_cols) * (expand_factor - 1)
  end

  def xrange(p, q) = ([p[1], q[1]].min..[p[1], q[1]].max)

  def yrange(p, q) = ([p[0], q[0]].min..[p[0], q[0]].max)

  def manhatten_dist(p, q) = (p[0] - q[0]).abs + (p[1] - q[1]).abs
end

Solution.new.run
