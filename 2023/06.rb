# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def part1
    times = extract_num(input[0])
    dists = extract_num(input[1])

    times.zip(dists)
      .map { |time, dist| winning_ways(time, dist) }
      .reduce(:*)
  end

  def part2
    time = extract_num(input[0]).map(&:to_s).reduce(&:concat).to_i
    dist = extract_num(input[1]).map(&:to_s).reduce(&:concat).to_i

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
