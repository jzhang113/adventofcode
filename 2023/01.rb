# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def part1
    find_sum
  end

  def part2
    mapping = {
      'eightwo' => '82',
      'eighthree' => '83',
      'twone' => '21',
      'oneight' => '18',
      'threeight' => '38',
      'fiveight' => '58',
      'nineight' => '98',
      'sevenine' => '79',
      'one' => '1',
      'two' => '2',
      'three' => '3',
      'four' => '4',
      'five' => '5',
      'six' => '6',
      'seven' => '7',
      'eight' => '8',
      'nine' => '9'
    }

    input.each do |line|
      mapping.each do |k, v|
        line.gsub!(k, v)
      end
    end

    find_sum
  end

  def find_sum
    line_nums = []

    input.each do |line|
      nums = extract_num(line)
      first_digit = nums.first.digits.last
      last_digit = nums.last.digits.first
      line_nums << 10 * first_digit + last_digit
    end

    line_nums.sum
  end
end

Solution.new.run
