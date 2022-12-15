#_frozen_string_literal: true

require_relative './base_solution'
require_relative '../input'

# Helper for treating multiple ranges as a single, possibly disjoint range
class MultiRange
  attr_accessor :ranges

  def initialize(ranges)
    @ranges = ranges.sort_by(&:begin)
  end

  def cover?(value)
    @ranges.any? { |r| r.cover?(value) }
  end

  def count
    @ranges.sum(&:count)
  end

  # Merge all ranges, assuming that the ranges are sorted by their begin values
  # Returns a new MultiRange object
  def merge_overlapping
    current = @ranges.first
    new_ranges = []

    @ranges.drop(1).each do |range|
      new_range = merge(current, range)

      if new_range.nil?
        new_ranges << current
        current = range
      else
        current = new_range
      end
    end

    new_ranges << current
    MultiRange.new(new_ranges)
  end

  # Merge two ranges, returns nil if they are disjoint
  def merge(range1, range2)
    return nil if range1.end < range2.begin || range2.end < range1.begin

    [range1.begin, range2.begin].min..[range1.end, range2.end].max
  end
end

class Solution < BaseSolution
  include Input

  def manhattan_dist(x1, y1, x2, y2)
    (x1 - x2).abs + (y1 - y2).abs
  end

  def scan_map
    @map = {}
    @beacons = Set.new

    input.each do |line|
      sensor_x, sensor_y, beacon_x, beacon_y = extract_num(line)
      dist = manhattan_dist(sensor_x, sensor_y, beacon_x, beacon_y)

      @map[[sensor_x, sensor_y]] = dist
      @beacons.add([beacon_x, beacon_y])
    end
  end

  def exclusion_range(row, map)
    ranges = []

    map.each do |sensor, radius|
      sensor_x, sensor_y = sensor
      vertical_dist = (sensor_y - row).abs

      next if vertical_dist >= radius

      horiz_dist = radius - vertical_dist
      range = (sensor_x - horiz_dist)..(sensor_x + horiz_dist)
      ranges << range
    end

    MultiRange.new(ranges).merge_overlapping
  end

  def before_block
    scan_map
  end

  def part1
    target_row = 2_000_000
    full_range = exclusion_range(target_row, @map)

    # Remove any beacons already on the row
    contained_beacons = @beacons.filter do |beacon_x, beacon_y|
      target_row == beacon_y && full_range.cover?(beacon_x)
    end.count

    full_range.count - contained_beacons
  end

  def part2
    4_000_000.times.each do |row|
      full_range = exclusion_range(row, @map)

      # If we have more than one range, assume that the gap is the missing beacon
      return (full_range.ranges[0].end + 1) * 4_000_000 + row if full_range.ranges.count > 1
    end
  end
end

Solution.new.run
