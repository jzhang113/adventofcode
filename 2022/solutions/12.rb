# frozen_string_literal: true

require_relative './base_solution'
require_relative '../input'
require_relative '../heap'

class Tile
  attr_accessor :value, :exits, :dist, :prev

  def initialize
    @exits = []
    @dist = 10_000
    @prev = nil
  end
end

class Solution < BaseSolution
  include Input

  EXCLUDED_INSTANCE_VARS << 'map'

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
            t.dist = 0
            @start_x = x
            @start_y = y
          end
        end
      end
    end

    @rows = @map.length
    @cols = @map[0].length

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
    x < @cols && x >= 0 && y < @rows && y >= 0 && map[y][x].value >= current - 1
  end

  def to_idx(x, y)
    y * @cols + x
  end

  def to_rc(idx)
    x = idx % @cols
    y = idx / @cols
    [x, y]
  end

  def dijkstra(map)
    queue = MinHeap.new

    map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        queue.insert(cell.dist, to_idx(x, y))
      end
    end

    until queue.empty? do
      prev_cost, prev_idx = queue.extract
      px, py = to_rc(prev_idx)

      map[py][px].exits.each do |dx, dy|
        new_idx = to_idx(px + dx, py + dy)

        cost = prev_cost + 1
        if cost < map[py + dy][px + dx].dist
          map[py + dy][px + dx].dist = cost
          map[py + dy][px + dx].prev = prev_idx
          queue.decrease_key(new_idx, cost)
        end
      end
    end
  end

  def part1
    parse_map
    dijkstra(@map)

    curr_x, curr_y = @end_x, @end_y
    steps = 0

    until curr_x == @start_x && curr_y == @start_y do
      curr_x, curr_y = to_rc(@map[curr_y][curr_x].prev)
      steps += 1
    end

    steps
  end

  def part2
    all_steps = []
    @map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next unless cell.value == 0

        curr_x, curr_y = x, y
        steps = 0

        until curr_x == @start_x && curr_y == @start_y do
          if @map[curr_y][curr_x].prev.nil?
            steps = 10_000
            break
          end

          curr_x, curr_y = to_rc(@map[curr_y][curr_x].prev)
          steps += 1
        end

        all_steps << steps
      end
    end

    all_steps.min
  end
end

Solution.new.run
