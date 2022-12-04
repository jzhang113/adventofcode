# frozen_string_literal: true

require_relative './base_solution'
require_relative '../input'

class Solution < BaseSolution
  include Input

  # Break each line up into two pairs of numbers
  def data
    input.map do |line|
      line
        .split(',')
        .map { |range| range.split('-').map(&:to_i) }
    end
  end

  # A region is fully contained if both endpoints are both bigger or both smaller than the other one
  def part1
    data.filter do |first, second|
      smaller = (first[0] <= second[0]) && (first[1] >= second[1])
      larger = (first[0] >= second[0]) && (first[1] <= second[1])
      smaller || larger
    end.count
  end

  # A region is fully disjoint if it ends before the other one starts or if it starts after the other one ends
  # All regions that aren't fully disjoint will have some overlap
  def part2
    data.filter do |first, second|
      ends_before = (first[1] < second[0])
      starts_after = (first [0] > second[1])
      !(ends_before || starts_after)
    end.count
  end
end

Solution.new.run
