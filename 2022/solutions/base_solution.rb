# frozen_string_literal: true

require 'active_support'
require 'active_support/all'

class BaseSolution
  # include Input in the subclass to make available an `input` accessor to the data

  def part1
    raise 'Implement your solution to part one of the problem'
  end

  def part2
    raise 'Implement your solution to part two of the problem'
  end

  def run
    day_num = File.basename($PROGRAM_NAME, '.rb').to_i
    puts "Running solution for day #{day_num}"
    puts "Part 1: #{part1}"
    puts "Part 2: #{part2}"
  end
end
