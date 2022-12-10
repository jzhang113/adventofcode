# frozen_string_literal: true

require_relative './base_solution'
require_relative '../input'

class Solution < BaseSolution
  include Input

  def signal_strength(num)
    num * @register[num - 1]
  end

  def part1
    @register = Array.new(240, 1)
    cycle = 0
    line = 0

    while cycle < 240
      op, num = input[line].split
      num = num.to_i if num.present?
      line += 1

      case op
      when 'noop'
        @register[cycle + 1] = @register[cycle]
        cycle += 1
      when 'addx'
        new_val = @register[cycle] + num
        @register[cycle + 1] = @register[cycle]
        @register[cycle + 2] = new_val
        cycle += 2
      end
    end

    (20..220).step(40).map { |n| signal_strength(n) }.reduce(:+)
  end

  def part2
    6.times.each do |row|
      40.times.each do |col|
        center = @register[row * 40 + col]
        sprite = (center - 1)..(center + 1)
        print sprite.cover?(col) ? '#' : '.'
      end
      puts
    end
  end
end

Solution.new.run
