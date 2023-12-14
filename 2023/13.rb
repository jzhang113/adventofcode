# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def before_block
    @grids = input.split('').map { |g| g.map(&:chars) }
  end

  def part1
    solve(0)
  end

  def part2
    solve(1)
  end

  def solve(error)
    horiz = @grids.filter_map { |g| any_sym_horiz?(g, error) }.sum
    vert = @grids.filter_map { |g| any_sym_horiz?(g.transpose, error) }.sum

    100 * horiz + vert
  end

  def any_sym_horiz?(grid, error)
    (2..grid.count).step(2) do |slice_size|
      return slice_size / 2 if sym_horiz?(grid.first(slice_size), error)
      return grid.count - slice_size / 2 if sym_horiz?(grid.last(slice_size), error)
    end

    false
  end

  def sym_horiz?(slice, error)
    mismatched_rows = (0..(slice.count - 1) / 2).filter { |n| slice[n] != slice[slice.count - n - 1] }
    return false if mismatched_rows.count > error

    mismatches = mismatched_rows.map do |n|
      slice[n].zip(slice[slice.count - n - 1]).count { |a, b| a != b }
    end.sum

    mismatches == error
  end
end

Solution.new.run
