# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'
require_relative '../lib/multirange'

class Solution < BaseSolution
  include Input

  def before_block
    @seeds = input[0].split[1..].map(&:to_i)
    @maps = input.split('')[1..].to_h { |section| [section[0], parse_map(section[1..])] }
  end

  def part1
    @seeds.map do |seed|
      @maps.reduce(seed) do |prev, (_, mapping)|
        process_map_single(prev, mapping)
      end
    end.min
  end

  def part2
    @seeds.each_slice(2).map do |start, len|
      seed_range = [start..(start + len)]

      @maps.reduce(seed_range) do |prev, (_, mapping)|
        process_map_ranges(prev, mapping)
      end
    end.flatten.map(&:begin).min
  end

  def parse_map(arr)
    arr.map do |line|
      dest, src, num = line.split.map(&:to_i)
      [dest..(dest + num), src..(src + num)]
    end
  end

  def process_map_single(input, map)
    map.each do |dest, src|
      return dest.begin + (input - src.begin) if src.cover? input
    end

    input
  end

  def process_map_ranges(ranges, map)
    new_ranges = []

    until ranges.empty?
      r = ranges.pop

      found_ranges = []
      map.each do |dest, src|
        intersect = src & r
        next if intersect.nil?

        found_ranges << intersect
        dest_start = dest.begin + (intersect.begin - src.begin)
        new_ranges << (dest_start..(dest_start + intersect.size))
      end

      remaining_ranges = MultiRange.new([r])
      remaining_ranges = found_ranges.reduce(remaining_ranges) do |prev, intersect|
        prev.difference(intersect)
      end

      new_ranges << remaining_ranges.ranges
    end

    new_ranges.flatten
  end
end

Solution.new.run
