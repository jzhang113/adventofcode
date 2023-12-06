# frozen_string_literal: true

require 'active_support'
require 'active_support/all'
require 'byebug'

class BaseSolution
  # include Input in the subclass to make available an `input` accessor to the data

  EXCLUDED_INSTANCE_VARS = ['input'].freeze

  # Override to implement behavior used by both parts of the solution
  def before_block; end

  def part1
    raise 'Implement your solution to part one of the problem'
  end

  def part2
    raise 'Implement your solution to part two of the problem'
  end

  def run
    day_num = File.basename($PROGRAM_NAME, '.rb').to_i
    puts "Running solution for day #{day_num}"

    before_block

    puts "Part 1: #{part1}"
    puts "Part 2: #{part2}"

    dump
  end

  def dump
    vars = instance_values.except(*EXCLUDED_INSTANCE_VARS)
    puts 'Instance variables:' if vars.present?

    vars.each do |key, value|
      puts "#{key} => #{value.inspect}"
    end

    nil
  end

  def extract_num(str)
    str.scan(/-?\d+/).map(&:to_i)
  end
end

class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end

class Range
  # Find the common elements of two ranges, returns nil if they are disjoint
  def intersection(other)
    return nil if self.end < other.begin || other.end < self.begin

    [self.begin, other.begin].max..[self.end, other.end].min
  end

  # Merge two ranges, returns nil if they are disjoint
  def union(other)
    return nil if self.end < other.begin || other.end < self.begin

    [self.begin, other.begin].min..[self.end, other.end].max
  end

  alias & :intersection
  alias + :union
end
