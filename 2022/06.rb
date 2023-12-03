# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def part1
    input[0].length.times do |i|
      phrase = input[0][i..(i + 3)]
      letters = phrase.split('')
      return (i + 4) if letters == letters.uniq
    end
  end

  def part2
    input[0].length.times do |i|
      phrase = input[0][i..(i + 13)]
      letters = phrase.split('')
      return (i + 14) if letters == letters.uniq
    end
  end
end

Solution.new.run
