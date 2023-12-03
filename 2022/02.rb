# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def data
    input
      .map { |line| line.split(' ').map(&:ord) }
      .map { |line| [line[0] - 'A'.ord, line[1] - 'X'.ord] }
  end

  # 0 is rock, 1 is paper, 2 is scissor
  def shape_score(shape)
    shape + 1
  end

  # 0 is loss, 1 is draw, 2 is win
  def result_score(result)
    result * 3
  end

  # Consider when the opponent has a rock; the mapping of your symbol => result is:
  #   0 => 1, 1 => 2, 2 => 0
  # Note that this is "one ahead" of the difference of (you - oppo)  % 3
  # This relation holds for each of the other symbols the opponent could have
  # Explaining why this is true is left as an exercise for the reader
  def part1
    data.map do |line|
      result = (line[1] - (line[0] - 1)) % 3
      shape_score(line[1]) + result_score(result)
    end.reduce(:+)
  end

  def part2
    data.map do |line|
      shape = (line[0] + (line[1] - 1)) % 3
      shape_score(shape) + result_score(line[1])
    end.reduce(:+)
  end
end

Solution.new.run
