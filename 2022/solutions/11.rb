# frozen_string_literal: true

require_relative './base_solution'
require_relative '../input'

class Monkey
  attr_accessor :inventory, :operation, :divisible, :next_if_true, :next_if_false, :inspected

  def initialize
    @inspected = 0
  end
end

class Solution < BaseSolution
  include Input

  def parse_rules
    monkeys = input.map(&:strip).split('')

    monkeys.map do |parts|
      Monkey.new.tap do |r|
        r.inventory = parts[1].scan(/\d+/).map(&:to_i)
        r.operation = parts[2][11..]
        r.divisible = parts[3].match(/\d+/)[0].to_i
        r.next_if_true = parts[4].match(/\d+/)[0].to_i
        r.next_if_false = parts[5].match(/\d+/)[0].to_i
      end
    end
  end

  # After increasing worry, apply an operation specified by block to keep worry values in check
  def run_round(monkeys, &block)
    monkeys.each do |monkey|
      monkey.inventory.each do |old|
        after = eval monkey.operation
        after = block.call(after) if block_given?

        if (after % monkey.divisible).zero?
          monkeys[monkey.next_if_true].inventory << after
        else
          monkeys[monkey.next_if_false].inventory << after
        end
      end

      monkey.inspected += monkey.inventory.length
      monkey.inventory = []
    end
  end

  # Multiply the two highest inspected counts
  def inspected_score(monkeys)
    monkeys.map(&:inspected).sort.reverse.take(2).reduce(:*)
  end

  def part1
    monkeys = parse_rules

    20.times do
      run_round(monkeys) { |m| m / 3 }
    end

    inspected_score(monkeys)
  end

  def part2
    monkeys = parse_rules
    sieve = monkeys.map(&:divisible).reduce(:lcm)

    10_000.times.each do
      run_round(monkeys) { |m| m % sieve }
    end

    inspected_score(monkeys)
  end
end

Solution.new.run
