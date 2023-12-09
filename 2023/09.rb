# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def part1
    input.map(&:extract_nums)
      .map { |line| calc_next(line) }
      .sum
  end

  def part2
    input.map(&:extract_nums)
      .map(&:reverse)
      .map { |line| calc_next(line) }
      .sum
  end

  def calc_next(nums)
    diffs = nums.each_cons(2).map { |a, b| b - a }
    next_offset = all_equal?(diffs) ? diffs[0] : calc_next(diffs)

    nums.last + next_offset
  end

  def all_equal?(arr)
    arr.all? { |x| x == x[0] }
  end
end

Solution.new.run
