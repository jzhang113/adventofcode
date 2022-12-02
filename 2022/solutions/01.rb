# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/array'
require_relative '../input'

class Solution
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

soln = Solution.new
puts soln.part1
puts soln.part2
