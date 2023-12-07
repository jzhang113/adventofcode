# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def part1
    times = input[0].extract_nums
    dists = input[1].extract_nums

    times.zip(dists)
      .map { |time, dist| winning_ways(time, dist) }
      .reduce(:*)
  end

  def part2
    time = input[0].extract_nums.map(&:to_s).reduce(&:concat).to_i
    dist = input[1].extract_nums.map(&:to_s).reduce(&:concat).to_i

    winning_ways(time, dist)
  end

  def winning_ways(time, dist)
    (1..time).each do |t|
      return nums_between(t, time - t) if (t * (time - t)) > dist
    end
  end

  def nums_between(a, b) = b - a + 1
end

Solution.new.run
