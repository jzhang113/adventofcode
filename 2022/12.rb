# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'
require_relative '../lib/pathfinding'

class Tile
  attr_accessor :value, :exits

  def initialize
    @exits = []
  end
end

class Solution < BaseSolution
  include Input

  EXCLUDED_INSTANCE_VARS << 'map'
  EXCLUDED_INSTANCE_VARS << 'prevs'

  def parse_map
    @map = input.map.with_index do |lines, y|
      lines.split('').map.with_index do |letter, x|
        Tile.new.tap do |t|
          t.value = letter.ord - 'a'.ord

          if t.value == 'S'.ord - 'a'.ord
            t.value = 0
            @end_x = x
            @end_y = y
          end

          if t.value == 'E'.ord - 'a'.ord
            t.value = 26
            @start_x = x
            @start_y = y
          end
        end
      end
    end

    @map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell.exits << [-1, 0] if can_enter(x - 1, y, cell.value, @map)
        cell.exits << [1, 0] if can_enter(x + 1, y, cell.value, @map)
        cell.exits << [0, -1] if can_enter(x, y - 1, cell.value, @map)
        cell.exits << [0, 1] if can_enter(x, y + 1, cell.value, @map)
      end
    end

    @map
  end

  def can_enter(x, y, current, map)
    x < map[0].length && x >= 0 && y < map.length && y >= 0 && map[y][x].value >= current - 1
  end

  def before_block
    parse_map
    _, @prevs = Pathfinding.dijkstra(@start_x, @start_y, @map)
  end

  def part1
    Pathfinding.path(@start_x, @start_y, @end_x, @end_y, @prevs).length - 1
  end

  def part2
    path_lengths = []

    @map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next unless cell.value.zero?

        path = Pathfinding.path(@start_x, @start_y, x, y, @prevs)
        path_lengths << path.length - 1 unless path.nil?
      end
    end

    path_lengths.min
  end
end

Solution.new.run
