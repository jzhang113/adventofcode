# frozen_string_literal: true

require_relative './heap'

# Pathfinding utilities
module Pathfinding
  module_function

  # map should be an array of array; each cell must contain a .exits method
  # returns [dists, prevs]
  # dists is an array of distances of each cell to the start
  # prevs is an array of cell references each pointing one step back to the start
  def dijkstra(start_x, start_y, map)
    queue = MinHeap.new
    rows = map.length
    cols = map[0].length

    dists = Array.new(rows) { Array.new(cols, 1_000_000) }
    prevs = Array.new(rows) { Array.new(cols) }
    dists[start_y][start_x] = 0

    map.each_with_index do |row, y|
      row.each_with_index do |_, x|
        queue.insert(dists[y][x], [x, y])
      end
    end

    until queue.empty?
      prev_cost, prev_idx = queue.extract
      px, py = prev_idx

      map[py][px].exits.each do |dx, dy|
        new_idx = [px + dx, py + dy]
        cost = prev_cost + 1

        next unless cost < dists[py + dy][px + dx]

        dists[py + dy][px + dx] = cost
        prevs[py + dy][px + dx] = prev_idx
        queue.decrease_key(new_idx, cost)
      end
    end

    [dists, prevs]
  end

  # prevs should be the result of a previous dijkstra call or another similar method that returns an array of steps from [start_x, start_y]
  # returns a list of cells on the path, including the start and end
  # returns nil if there is no path
  def path(start_x, start_y, end_x, end_y, prevs)
    path = [[end_x, end_y]]
    curr_x = end_x
    curr_y = end_y

    until curr_x == start_x && curr_y == start_y
      return nil if prevs[curr_y][curr_x].nil?

      curr_x, curr_y = prevs[curr_y][curr_x]
      path << [curr_x, curr_y]
    end

    path.reverse
  end
end
