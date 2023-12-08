# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def before_block
    @dirs = input[0].chars.cycle
    @nodes = input.drop(2).map do |line|
      line =~ /(\w+) = \((\w+), (\w+)\)/
      [Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3)]
    end
  end

  def part1
    solve_path('AAA')
  end

  def part2
    @nodes.select { |n| n[0][2] == 'A' }
      .map(&:first)
      .map { |n| solve_path(n) }
      .reduce(&:lcm)
  end

  def solve_path(node)
    @dirs.each_with_index do |dd, steps|
      idx = @nodes.find_index { |n| n[0] == node }
      node = dd == 'L' ? @nodes[idx][1] : @nodes[idx][2]

      return steps + 1 if node[2] == 'Z'
    end
  end
end

Solution.new.run
