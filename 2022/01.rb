# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def sums
    input
      .split('')
      .map { |chunk| chunk.map(&:to_i).reduce(:+) }
  end

  def part1
    sums.max
  end

  def part2
    sums.max(3).reduce(:+)
  end
end

Solution.new.run
