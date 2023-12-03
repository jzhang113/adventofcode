# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Pair
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    self.class.new(x, y).tap do |result|
      result.x += other.x
      result.y += other.y
    end
  end

  def -(other)
    self.class.new(x, y).tap do |result|
      result.x -= other.x
      result.y -= other.y
    end
  end

  def eql?(other)
    x == other.x && y == other.y
  end

  def hash
    x * 9917 + y * 257
  end
end

class Solution < BaseSolution
  include Input

  EXCLUDED_INSTANCE_VARS << 'dir_map'

  def dir_map
    @dir_map = {
      'L' => Pair.new(-1, 0),
      'R' => Pair.new(1, 0),
      'D' => Pair.new(0, 1),
      'U' => Pair.new(0, -1)
    }
  end

  def drag_tail(head, tail)
    diff = head - tail
    return tail if diff.x.abs <= 1 && diff.y.abs <= 1

    dirx = diff.x <=> 0
    diry = diff.y <=> 0
    tail + Pair.new(dirx, diry)
  end

  def part1
    head = Pair.new(0, 0)
    tail = Pair.new(0, 0)
    visited = Set.new([Pair.new(0, 0)])

    input.each do |line|
      dir, num = line.split
      move = dir_map[dir]

      num.to_i.times do
        head += move
        tail = drag_tail(head, tail)
        visited << tail
      end
    end

    visited.length
  end

  def part2
    knots = Array.new(10, Pair.new(0, 0))
    visited = Set.new([Pair.new(0, 0)])

    input.each do |line|
      dir, num = line.split
      move = dir_map[dir]

      num.to_i.times do
        knots[0] += move
        (1..9).each do |n|
          knots[n] = drag_tail(knots[n - 1], knots[n])
        end
        visited << knots[9]
      end
    end

    visited.length
  end
end

Solution.new.run
