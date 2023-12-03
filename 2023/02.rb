# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def part1
    games = []

    input.each do |line|
      line =~ /Game (\d+): (.+)/
      game_num = Regexp.last_match(1).to_i
      game_data = Regexp.last_match(2)
      game_valid = true

      game_data.scan(/[\w, ]+;?/) do |record|
        record.strip!
        record.delete!(';')

        record.split(', ').each do |cube|
          count, type = cube.split(' ')
          count = count.to_i

          game_valid = false if type == 'red' && count > 12
          game_valid = false if type == 'green' && count > 13
          game_valid = false if type == 'blue' && count > 14
        end
      end

      games << game_num if game_valid
    end

    games.sum
  end

  def part2
    pows = []

    input.each do |line|
      line =~ /Game (\d+): (.+)/
      game_data = Regexp.last_match(2)
      mins = [0, 0, 0]

      game_data.scan(/[\w, ]+;?/) do |record|
        record.strip!
        record.delete!(';')

        record.split(', ').each do |cube|
          count, type = cube.split(' ')
          count = count.to_i

          mins[0] = [mins[0], count].max if type == 'red'
          mins[1] = [mins[1], count].max if type == 'green'
          mins[2] = [mins[2], count].max if type == 'blue'
        end
      end

      pows << mins.reduce(:*)
    end

    pows.sum
  end
end

Solution.new.run
