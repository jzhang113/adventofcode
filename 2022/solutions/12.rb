# frozen_string_literal: true

require_relative './base_solution'
require_relative '../input'

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

  # Insert element into ASC sorted array.
  def heap_push(arr, x)
    idx = arr.bsearch_index { |y| (y[0] <=> x[0]) >= 0 } || arr.size
    arr.insert(idx, x)
  end

  # Remove element from ASC sorted array if the element is present.
  def heap_pop(arr, x)
    idx = arr.bsearch_index { |y| (y[0] <=> x[0]) >= 0 }
    arr.delete_at(idx) if idx && arr[idx][0] == x[0]
  end

  def heap_pop_val(arr, val)
    idx = arr.index { |y| y[1] == val }
    arr.delete_at(idx) if idx && arr[idx][1] == val
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
    queue = []

    map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        heap_push(queue, [cell.dist, to_idx(x, y)])
      end
    end

    until queue.empty? do
      top = queue.shift
      t_x, t_y = to_rc(top[1])

      map[t_y][t_x].exits.each do |dx, dy|
        new_idx = to_idx(t_x + dx, t_y + dy)
        elem = heap_pop_val(queue, new_idx)
        next if elem.nil?

        alt = map[t_y][t_x].dist + 1
        if alt < map[t_y + dy][t_x + dx].dist
          map[t_y + dy][t_x + dx].dist = alt
          map[t_y + dy][t_x + dx].prev = top[1]
          elem[0] = alt
        end

        heap_push(queue, elem)
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
