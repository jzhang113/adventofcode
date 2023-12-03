# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  # Break each line up into two sets of items
  def data
    input.map do |sack|
      left = sack[..(sack.length/2 - 1)]
      right = sack[(sack.length/2)..]

      left_set = Set.new(left.split(''))
      right_set = Set.new(right.split(''))

      [left_set, right_set]
    end
  end

  # Take the intersection of the sets to find the duplicate items
  # Then convert the items to their priority values and find the sum
  def part1
    data
      .map { |left, right| (left & right).to_a }
      .reduce(:+)
      .map { |value| priority(value) }
      .reduce(:+)
  end

  # Take the union of the sets to find all items in each rucksack
  # Then take the intersection of all rucksacks in a group to find the badge
  # Then convert the badges to their priority values and find the sum
  def part2
    data
      .map { |left, right| (left | right) }
      .in_groups_of(3)
      .map { |group| group.reduce(:&).to_a }
      .reduce(:+)
      .map { |value| priority(value) }
      .reduce(:+)
  end

  def priority(item)
    value = item.ord
    if value <= 'Z'.ord
      value - 'A'.ord + 27
    else
      value - 'a'.ord + 1
    end
  end
end

Solution.new.run
