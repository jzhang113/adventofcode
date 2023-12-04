# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def part1
    total = 0

    input.each do |line|
      line =~ /Card +(\d+): ([\d ]+)\| ([\d ]+)/
      scoring = Regexp.last_match(2).split(' ').map(&:to_i)
      nums = Regexp.last_match(3).split(' ').map(&:to_i)

      score = nums.select { |n| scoring.include?(n) }.count
      total += 2**(score - 1) if score > 0
    end

    total
  end

  def part2
    cards = Array.new(192, 1)

    input.each do |line|
      line =~ /Card +(\d+): ([\d ]+)\| ([\d ]+)/
      card_num = Regexp.last_match(1).to_i
      scoring = Regexp.last_match(2).split(' ').map(&:to_i)
      nums = Regexp.last_match(3).split(' ').map(&:to_i)

      score = nums.select { |n| scoring.include?(n) }.count

      if score > 0
        ((card_num + 1)..([card_num + score, 192].min)).each do |new_card_num|
          cards[new_card_num - 1] += cards[card_num - 1]
        end
      end
    end

    cards.sum
  end
end

Solution.new.run
