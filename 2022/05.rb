# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  attr_accessor :crates

  def reset_crates
    self.crates = [%w[M J C B F R L H],
                   %w[Z C D],
                   %w[H J F C N G W],
                   %w[P J D M T S B],
                   %w[N C D R J],
                   %w[W L D Q P J G Z],
                   %w[P Z T F R H],
                   %w[L V M G],
                   %w[C B G P F Q R J]]
  end

  def moves
    input.split('')[1].map do |line|
      parts = line.split(' ')
      [parts[1], parts[3], parts[5]].map(&:to_i)
    end
  end

  def make_move(count, from, to)
    count.times do
      moved = crates[from - 1].pop
      crates[to - 1].push(moved)
    end
  end

  def make_multi_move(count, from, to)
    moved = crates[from - 1].pop(count)
    crates[to - 1].concat(moved)
  end

  def part1
    reset_crates

    moves.each do |count, from, to|
      make_move count, from, to
    end

    crates.map(&:last).join
  end

  def part2
    reset_crates

    moves.each do |count, from, to|
      make_multi_move count, from, to
    end

    crates.map(&:last).join
  end
end

Solution.new.run
